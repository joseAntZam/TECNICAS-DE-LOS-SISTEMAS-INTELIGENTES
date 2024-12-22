package tracks.singlePlayer.evaluacion.src_ZAMORA_REYES_JOSEANTONIO;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.PriorityQueue;
import java.util.Stack;
import core.game.Observation;
import core.game.StateObservation;
import core.player.AbstractPlayer;
import ontology.Types;
import ontology.Types.ACTIONS;
import tools.ElapsedCpuTimer;
import tools.Vector2d;


public class AgenteDijkstra extends AbstractPlayer{

		Vector2d fescala;
		Vector2d portal;
		public ArrayList<Observation>[] vector_obstaculos;
		ArrayList<ArrayList<Boolean>> matriz_obstaculos;
		public double tiempo;
		int nodos_expandidos;
		HashSet<Integer> claves_nodos_visitados;
		Stack<ACTIONS>ruta;
		

		public AgenteDijkstra(StateObservation stateObs, ElapsedCpuTimer elapsedTimer){
			//Inicializamos todas la varibles.
			tiempo=0.0;//En esta se almacenará el tiempo que tarda la ejecución
			nodos_expandidos = 0;//En esta se almacenarán los nodos expandidos
			ruta =  new Stack<>(); //Pila donde guardamos las acciones de la ruta
			claves_nodos_visitados = new HashSet<>(); //Hashset donde guardamos los identificadores de los nodos visitados
			
			this.matriz_obstaculos = new ArrayList<>(); //En esta matriz almacenaremos los obstáculos que encontramos en el mapa , en ella true indicará 
			//que hay un obstáculo y false que no lo hay.
			
			
			//Calculamos el factor de escala entre mundos ( pixeles -> grid)
			fescala = new Vector2d(stateObs.getWorldDimension().width / stateObs.getObservationGrid().length , stateObs.getWorldDimension().height / stateObs.getObservationGrid()[0].length);
			
			//Se crea una lista de observaciones de portales , ordenada por cercania al avatar.
			ArrayList<Observation>[] posiciones = stateObs.getPortalsPositions(stateObs.getAvatarPosition());
			
			
			//Selecciona el portal más próximo
			portal = posiciones[0].get(0).position;
			portal.x = Math.floor(portal.x / fescala.x);
			portal.y = Math.floor(portal.y / fescala.y);
			
			//Inicializamos toda la matriz de obstaculos a false y establecemos la heuristica inicial que es igual a la distancia manhattan.
			//al terminar este bucle como resultado tendremos rellena la_matriz de obstaculos ,la cual tiene las dimensiones del mapa, entera a false, 
			//es decir, como si no hubiesen obtaculos por el momento , del mismo modo tendremos valor_heuristica , que es también una matriz la
			//cual tiene las mismas dimensiones que el mapa , rellena con la propia heuristica de cada casilla.						
			for ( int i = 0 ; i < stateObs.getObservationGrid().length ; i++) {
				matriz_obstaculos.add(new ArrayList<Boolean>());
				for(int j = 0 ; j < stateObs.getObservationGrid()[0].length; j++ ){	
					matriz_obstaculos.get(i).add(false);
				}
			}
			
			//Almacenamos en vector_obstaculos las posiciones en las cuales existan muros o trampas
			vector_obstaculos = stateObs.getImmovablePositions();
			
			//Almacenado en vector_obtaculos dichas posiciones , procedemos a ponerlas a true en  matriz_obstaculos , lo cual indica que existe un muro o trampa
			for(int i = 0; i<vector_obstaculos.length; i++){
				//Almacenado en vector_obtaculos dichas posiciones , procedemos a ponerlas a true en  matriz_obstaculos , lo cual indica que existe un muro o trampa				
				for(int j = 0 ; j<vector_obstaculos[i].size();j++) {
					
					Vector2d posible_obstaculo = vector_obstaculos[i].get(j).position;
					posible_obstaculo.x = Math.floor(posible_obstaculo.x/fescala.x);
					posible_obstaculo.y = Math.floor(posible_obstaculo.y/fescala.y);
					matriz_obstaculos.get((int)posible_obstaculo.x).set((int)posible_obstaculo.y, true);
				}	
			}
		}
		
							
		public Stack<ACTIONS>Dijskstra(StateObservation stateObs, ElapsedCpuTimer elapsedTimer){
			
			
			//posicion actual del avatar
			Vector2d posicion_avatar = new Vector2d(stateObs.getAvatarPosition().x / fescala.x , stateObs.getAvatarPosition().y /fescala.y);
			//creamos el nodo en el que nos encontramos
			NodoDijkstra nodoActual = new NodoDijkstra(posicion_avatar, stateObs.getAvatarOrientation());
			//Cola con propiedad donde iremos guardando los nodos a expandir
			PriorityQueue<NodoDijkstra> frontera = new PriorityQueue<>();
			//Añadimos el nodo actual para poder ejecutar bien el siguiente bucle
			frontera.add(nodoActual);
			
			while (true) {
				//sacamos de frontera el nodo con menor distancia
				nodoActual = frontera.poll();
				//Si este nodo es el portal , hemos terminado
				if (nodoActual.esIgual(portal.x,portal.y)) {
					break;
				}
				
				//lo metemos el el hashset creado anteriormente esto nos servirá para evitar nodos duplicados en frontera
				claves_nodos_visitados.add(nodoActual.identificado_nodo);
				nodos_expandidos++;
				
				//Expandimos nodos vecinos
				ArrayList<NodoDijkstra> nodos_vecinos = nodoActual.expandirNodosVecinos();
				
				//De los nodos vecinos comprobamos si no son obtaculos , si no pertenecen ya a la frontera y si su distancia es mayor que la del nodo 
				// actual mas 1 , si se cumple todo esto lo almacenamos en frontera para expandirlo .
				int index = 0;
				while (index < nodos_vecinos.size()) {
				    if (!matriz_obstaculos.get((int)nodos_vecinos.get(index).coordenadas.x).get((int)nodos_vecinos.get(index).coordenadas.y) && 
				        !claves_nodos_visitados.contains(nodos_vecinos.get(index).identificado_nodo) &&
				        nodos_vecinos.get(index).distancia > nodoActual.distancia + 1) {
					    	nodos_vecinos.get(index).distancia = nodoActual.distancia + 1;
					        frontera.add(nodos_vecinos.get(index));
				    }
				    index++;
				}	
			}
			//Devolvemos el conjunto de acciones
			return nodoActual.obtenerRuta();
		}
		
		
		

		@Override
		public Types.ACTIONS act(StateObservation stateObs, ElapsedCpuTimer elapsedTimer) {
			
			//si la ruta no tiene acciones , aplicamos Dijkstra para rellenarla y ya simplemente iremos sacando acciones de esta ruta.
			if (ruta.size()==0){
				double calculo_ruta = System.nanoTime();
				ruta = Dijskstra(stateObs, elapsedTimer);
				long fin_ruta = System.nanoTime();
				double tiempo = (fin_ruta - calculo_ruta) / 1000000;
				int tamaño_ruta = ruta.size()-1;
				System.out.printf("TIEMPO (ms) -->" + tiempo + "\n");
				System.out.printf("NUMERO DE NODOS EXPANDIDOS -->" + nodos_expandidos + "\n");
				System.out.printf("TAMAÑO RUTA -->" + tamaño_ruta + "\n");
			}
			return ruta.pop();
			
		}
		
}












