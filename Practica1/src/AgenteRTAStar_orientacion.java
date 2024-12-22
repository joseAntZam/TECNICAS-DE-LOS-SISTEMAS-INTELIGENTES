package tracks.singlePlayer.evaluacion.src_ZAMORA_REYES_JOSEANTONIO;
import core.game.StateObservation;
import core.game.Observation;
import tools.ElapsedCpuTimer;
import core.player.AbstractPlayer;
import tools.Vector2d;
import java.util.ArrayList;
import java.util.Collections;
import ontology.Types;
import ontology.Types.ACTIONS;
import java.util.HashSet;

public class AgenteRTAStar_orientacion extends AbstractPlayer{
	
	public Vector2d fescala;
	public Vector2d portal;
	public Vector2d orientacion;
	public ArrayList<ArrayList<Boolean>> matriz_obstaculos;
	public ArrayList<ArrayList<Integer>> valor_heuristica;
	public ArrayList<Observation>[] vector_obstaculos;
	public double tiempo;
	public int nodos_expandidos;
	public int tamaño_ruta;
	public int coste_rotacion;
	Vector2d posicion_avatar;
	HashSet<Integer> nodos;
	
	//Utilizo las dos siguientes funciones para identificar de forma unica a cada nodo , esto es util para poder saber cuales son los nodos expandidos.
	private int identificar(Vector2d posicion_avatar) {
        
        String idString = posicion_avatar.x + "," + posicion_avatar.y ;
        return idString.hashCode();
    }
	
	@Override
	public int hashCode() {
		return identificar(posicion_avatar);
	}
	
	public AgenteRTAStar_orientacion(StateObservation stateObs , ElapsedCpuTimer elapsedTimer){
		//Inicializamos todas la varibles.
		posicion_avatar = new Vector2d();
		nodos = new HashSet<>();//En este almaceno las claves de los nodos que ya he expandido
		tiempo = 0.0; //En esta se almacenará el tiempo que tarda la ejecución
		nodos_expandidos = 0; //En esta se almacena los nodos expandidos
		tamaño_ruta = 0; //tamaño de la ruta hasta el portal
		coste_rotacion=0; //Esta varible es util para controlar los costes de rotacion es los moviemntos de casillas , estará inicializada a 0 y su valor
		//será 0 o 1 , dependiendo de si es necesario o no rotación para hacer un moviento.
		this.matriz_obstaculos = new ArrayList<>(); //En esta matriz almacenaremos los obstáculos que encontramos en el mapa , en ella true indicará 
		//que hay un obstáculo y false que no lo hay.
		this.valor_heuristica = new ArrayList<>();  //En esta matriz alamcenamos el valor de la heurística propia de cada casilla.
		
		//Calculamos el factor de escala entre mundos ( pixeles -> grid)
		fescala = new Vector2d(stateObs.getWorldDimension().width / stateObs.getObservationGrid().length , stateObs.getWorldDimension().height / stateObs.getObservationGrid()[0].length);
		
		//Se crea una lista de observaciones de portales , ordenada por cercania al avatar.
		ArrayList<Observation>[] posiciones = stateObs.getPortalsPositions(stateObs.getAvatarPosition());
		
		
		//Selecciona el portal más próximo
		portal = posiciones[0].get(0).position;
		portal.x = Math.floor(portal.x / fescala.x);
		portal.y = Math.floor(portal.y / fescala.y);
		
		
		orientacion = new Vector2d(stateObs.getAvatarOrientation().x , stateObs.getAvatarOrientation().y);
		
		//Inicializamos toda la matriz de obstaculos a false y establecemos la heuristica inicial que es igual a la distancia manhattan.
		//al terminar este bucle como resultado tendremos rellena la_matriz de obstaculos ,la cual tiene las dimensiones del mapa, entera a false, 
		//es decir, como si no hubiesen obtaculos por el momento , del mismo modo tendremos valor_heuristica , que es también una matriz la
		//cual tiene las mismas dimensiones que el mapa , rellena con la propia heuristica de cada casilla.
		for ( int i = 0 ; i < stateObs.getObservationGrid().length ; i++) {
			matriz_obstaculos.add(new ArrayList<Boolean>());
			valor_heuristica.add(new ArrayList<Integer>());
			for(int j = 0 ; j < stateObs.getObservationGrid()[0].length; j++ ){	
				matriz_obstaculos.get(i).add(false);
				int distancia = (int)(Math.abs(portal.y-j) + Math.abs(portal.x -i));
				valor_heuristica.get(i).add(distancia);
			}
		}
		

		//Almacenamos en vector_obstaculos las posiciones en las cuales existan muros o trampas
		vector_obstaculos = stateObs.getImmovablePositions();
		
		//Almacenado en vector_obtaculos dichas posiciones , procedemos a ponerlas a true en  matriz_obstaculos , lo cual indica que existe un muro o trampa
		for(int i = 0; i<vector_obstaculos.length; i++){
			
			for(int j = 0 ; j<vector_obstaculos[i].size();j++) {
				
				Vector2d posible_obstaculo = vector_obstaculos[i].get(j).position;
				posible_obstaculo.x = Math.floor(posible_obstaculo.x/fescala.x);
				posible_obstaculo.y = Math.floor(posible_obstaculo.y/fescala.y);
				matriz_obstaculos.get((int)posible_obstaculo.x).set((int)posible_obstaculo.y, true);
			}	
		}
	}

	
	@Override
	public Types.ACTIONS act(StateObservation stateObs , ElapsedCpuTimer elapsedTimer) {
		
		//tiempo que se tarda en calcular la ruta
		double calculo_ruta = System.nanoTime();
		
		//posicion actual del avatar
		posicion_avatar = new Vector2d(stateObs.getAvatarPosition().x / fescala.x , stateObs.getAvatarPosition().y /fescala.y);
		
		
		
		//La siguiente accion a realizar
		ACTIONS accion_siguiente = Types.ACTIONS.ACTION_NIL;
		
		//Las siguientes líneas , son exactamente las mismas que en el constructor, es necesario actualizar los obtaculos que encontramos, debido
		//a que en determinados mapas no podemos acceder a la visión del mapa al completo , serán las casillas de visibilidad , las que nos proporcionen
		//la visibilidad restante , para ello al encontrar estas casillas debemos comprobar nuevamente los obtáculos para poder seguir con el movimiento.
		vector_obstaculos = stateObs.getImmovablePositions();
		for(int i = 0; i<vector_obstaculos.length; i++){
			
			for(int j = 0 ; j<vector_obstaculos[i].size();j++) {
				
				Vector2d posible_obstaculo = vector_obstaculos[i].get(j).position;
				posible_obstaculo.x = Math.floor(posible_obstaculo.x/fescala.x);
				posible_obstaculo.y = Math.floor(posible_obstaculo.y/fescala.y);
				matriz_obstaculos.get((int)posible_obstaculo.x).set((int)posible_obstaculo.y, true);
			}
			
		}
		
		//En este ArrayList metemos los valores de las heuristicas de las casillas vecinas que no son ni muros ni trampas,
		//Metemos las heuristicas junto a su coste de rotacion hacia la casilla debido a que este ArrayList será útil para determinar 
		//con que heurística actualizamos, el coste del movimiento lo sumo a la hora de actualizar la heuristica.
		ArrayList<Integer> frontera = new ArrayList<Integer>();
		
		//Fijamos una varible elegido en infinito , esto nos sirve para determinar la accion a realizar
		int elegido = (int) Double.POSITIVE_INFINITY;
				
		//Miramos posiciones de nuestras casillas vecinas.
		Vector2d arriba = new Vector2d(posicion_avatar.x , posicion_avatar.y-1);
		Vector2d abajo= new Vector2d(posicion_avatar.x , posicion_avatar.y+1);
		Vector2d izquierda= new Vector2d(posicion_avatar.x-1 , posicion_avatar.y);
		Vector2d derecha=  new Vector2d(posicion_avatar.x+1 , posicion_avatar.y);
		
		//Calculamos la heuristica de las casillas vecinas
		int heuristica_arriba = valor_heuristica.get((int)arriba.x).get((int)arriba.y);
		int heuristica_abajo = valor_heuristica.get((int)abajo.x).get((int)abajo.y);
		int heuristica_izquierda = valor_heuristica.get((int)izquierda.x).get((int)izquierda.y);
		int heuristica_derecha = valor_heuristica.get((int)derecha.x).get((int)derecha.y);
		
		
		//Es una varible que guardara una posición la cual nos servirá para saber si la accion que hemos realizado nos ha llevado al portal objetivo.
		Vector2d posible_portal = new Vector2d();
		
		//Miro cual es la orientacion del avatar.
		orientacion = new Vector2d(stateObs.getAvatarOrientation().x , stateObs.getAvatarOrientation().y);
		
		//Utilizo un boleano por cada vecino el cual me va a determinar si el objeto ha cambiado o no de casilla o simplemente ha hecho una rotación;
		boolean cambio_casilla_arriba = true;
		boolean cambio_casilla_abajo = true;
		boolean cambio_casilla_izquierda = true;
		boolean cambio_casilla_derecha = true;
		
		//En el caso de que la orientación sea distinta a (x = 0 , y = -1 --> "si el avatar apunta hacia arriba") , aumentaremos en uno el valor de la 
		//heuristica que hemos obtenido de la casilla de arriba y pondremos cambio_casilla_arriba a false.
		if((orientacion.x == 0 && orientacion.y == 1) || (orientacion.x == 1 && orientacion.y == 0) || (orientacion.x == -1 && orientacion.y == 0)) {
			 heuristica_arriba +=1;
			 cambio_casilla_arriba = false;
		}
		//En el caso de que la orientación sea distinta a (x = 0 , y = 1 --> "si el avatar apunta hacia abajo") , aumentaremos en uno el valor de la 
		//heuristica que hemos obtenido de la casilla de abajo y pondremos cambio_casilla_abajo a false.
		if((orientacion.x == 0 && orientacion.y == -1) || (orientacion.x == 1 && orientacion.y == 0) || (orientacion.x == -1 && orientacion.y == 0)) {
			 heuristica_abajo+=1;
			 cambio_casilla_abajo = false;
		}
		//En el caso de que la orientación sea distinta a (x = -1 , y = 0 --> "si el avatar apunta hacia izquierda") , aumentaremos en uno el valor de la 
				//heuristica que hemos obtenido de la casilla de la izquierda y pondremos cambio_casilla_izquierda a false.
		if((orientacion.x == 0 && orientacion.y == -1) || (orientacion.x == 0 && orientacion.y == 1) || (orientacion.x == 1 && orientacion.y == 0)) {
			 heuristica_izquierda+=1;
			 cambio_casilla_izquierda = false;
		}
		//En el caso de que la orientación sea distinta a (x = 1 , y = 0 --> "si el avatar apunta hacia derecha") , aumentaremos en uno el valor de la 
		//heuristica que hemos obtenido de la casilla de la derecha y pondremos cambio_casilla_derecha a false.
		if((orientacion.x == 0 && orientacion.y == -1) || (orientacion.x == 0 && orientacion.y == 1) || (orientacion.x == -1 && orientacion.y == 0)) {
			 heuristica_derecha+=1;
			 cambio_casilla_derecha = false;
		}
		
		
		//Vemos si la casilla de arriba es un muro o una trampa , en el caso de que no sea lo almacenamos en el ArrayList frontera la heuristica,
		//vemos si el valor de esta heurística, es menor, que el valor que tenemos en la varible elegido , en el caso que lo sea hacemos lo siguiente:
				//Actualizamos elegido con la nueva heuristica.
				//Almaceno en posible_portal las coordenadas de la casilla de arriba, esto será util para comprobar si la casilla a la que nos vamos a mover
					//es un portal y en ese caso poder mostrar por pantalla informacion de tiempo , nodos ...etc
				//Almaceno en accion_siguiente la acción.
		
		//Hacemos exactamente lo mismo con todas las casilla , de manera que cuando temrinemos de hacer todos los if , tendremos almacenado en elegido la mejor
		//heurística , en posible_portal la posicion de la casilla que nos proporciona mejor heuristica y en accion_siguiente , aquella que tengamos que realizar
		//para llegar a la casilla
		
		if(!matriz_obstaculos.get((int)arriba.x).get((int)arriba.y)){
			frontera.add(heuristica_arriba);
			if(heuristica_arriba < elegido){
				posible_portal = arriba;
				elegido = heuristica_arriba;
				accion_siguiente = Types.ACTIONS.ACTION_UP;
				}
			
		}
		if(!matriz_obstaculos.get((int)abajo.x).get((int)abajo.y)){
			frontera.add(heuristica_abajo);
			if(heuristica_abajo < elegido){
				posible_portal = abajo;
				elegido = heuristica_abajo;
				accion_siguiente = Types.ACTIONS.ACTION_DOWN;
				}
		}
		
		if(!matriz_obstaculos.get((int)izquierda.x).get((int)izquierda.y)){
			frontera.add(heuristica_izquierda);
			if(heuristica_izquierda < elegido){
				posible_portal = izquierda;
				elegido = heuristica_izquierda;
				accion_siguiente = Types.ACTIONS.ACTION_LEFT;
				}
		}
		
		if(!matriz_obstaculos.get((int)derecha.x).get((int)derecha.y)){
			frontera.add(heuristica_derecha);
			if(heuristica_derecha < elegido){
				posible_portal = derecha;
				elegido = heuristica_derecha;
				accion_siguiente = Types.ACTIONS.ACTION_RIGHT;
				}
			
		}
		
		
		
		
		//En if anteriores comprobamos las orientaciones indicando con booleanos si es posible realizar el cambio de casilla.
		//Con los siguientes if comprobamos que si la accion la cual hemos determinado como la mejor , nos permite movernos a otra casilla,
		//o simplemente realizar una rotacion , en el caso de que no podamos movernos con dicha accion a otra casilla , pondremos a 1 la 
		//variable coste_rotacion
		
		if(accion_siguiente == Types.ACTIONS.ACTION_UP && !cambio_casilla_arriba) {
			coste_rotacion=1;
		}
		if(accion_siguiente == Types.ACTIONS.ACTION_DOWN && !cambio_casilla_abajo) {
			coste_rotacion=1;
		}
		if(accion_siguiente == Types.ACTIONS.ACTION_LEFT && !cambio_casilla_izquierda) {
			coste_rotacion=1;
		}
		if(accion_siguiente == Types.ACTIONS.ACTION_RIGHT && !cambio_casilla_derecha) {
			coste_rotacion=1;
		}
		
		
		
		//Por el contrario si la accion seleccionada como la mejor , nos permite hacer un movimiento hacia otra casilla , actualizaremos la heuristica de la casilla
		//en la que nos encontramos.
		if((accion_siguiente == Types.ACTIONS.ACTION_UP && cambio_casilla_arriba)||
			(accion_siguiente == Types.ACTIONS.ACTION_DOWN && cambio_casilla_abajo)||
			(accion_siguiente == Types.ACTIONS.ACTION_LEFT && cambio_casilla_izquierda)||
			(accion_siguiente == Types.ACTIONS.ACTION_RIGHT && cambio_casilla_derecha))
		{
			//Ordenamos las heuristicas de los vecinos posibles en frontera, tenemos en este caso la heuristica , sin la rotacion que hemos necesitado hacer,
			//y sin el coste de movernos.
			Collections.sort(frontera);
			
			int heuristica_resultante = 0;
			int heuristica_actual = valor_heuristica.get((int)posicion_avatar.x).get((int)posicion_avatar.y);
			
			//Si el vector frontera solo tiene almacenado un valor , no me queda de otra que actualizar con ese , en el caso de que haya más de un valor ,
			//actualizo con el segundo mejor (RTA*)
			int posicion_heuristica = 0;
			if(frontera.size() == 1) {
				posicion_heuristica = 0;
			}
			else {
				posicion_heuristica = 1;
			}
			
			//Calculo la heurística resultante , teniendo en cuenta la el coste de la rotacion y el coste de moverme a la siguiente casilla.
			heuristica_resultante = Math.max( heuristica_actual , frontera.get(posicion_heuristica)+1+coste_rotacion);
			
			//Actualizo heuriística de mi casilla
			valor_heuristica.get((int) posicion_avatar.x).set((int)posicion_avatar.y,heuristica_resultante);
			
			//Pongo coste_rotacion a 0 , debido a que ya esta hecha la accion , en siguientes llamadas a act , se ira actualizando esta variable pudiendo 
			//valer 0 o 1 según el movimiento haya requerido o no un cambio de rotación.
			coste_rotacion = 0;
		}
		
		//Si el nodo que visitamos no es un portal , pues sumaremos uno al tamaño de la ruta,
		//Cuando sea un portal no se sumará , esto es debido a que yo cuento desde un inicio 
		//el nodo inicial , tengo en cuenta que el nodo se quede en la misma casilla.
		//en este caso tambien se incrementa tamaño_ruta
		if(portal.x != posible_portal.x || portal.y != posible_portal.y) {
			tamaño_ruta++;
		}
		
		//Identifico el nodo que visitado y si este ya esta añadido en el hashset "nodos" no 
		//lo cuento como nuevo nodo expandido , en el caso de que no este en el hashset , incremento
		//la variable nodos_expandidos y añado la clave del nodo al hashset
		int clave = identificar(posicion_avatar);
		
		if(!nodos.contains(clave)){
			nodos_expandidos++;
			nodos.add(clave);
		}
		
		
		double fin_ruta = System.nanoTime();
		tiempo += (fin_ruta-calculo_ruta)/1000000;
		if(portal.x == posible_portal.x && portal.y == posible_portal.y){
				
				System.out.printf("TIEMPO (ms) -->" + tiempo + "\n");
				System.out.printf("TAMAÑO RUTA -->" + tamaño_ruta + "\n");
				System.out.printf("NODOS EXPANDIDOS -->" + nodos_expandidos + "\n");
				
		}
		
		return accion_siguiente;
	}
	
}
