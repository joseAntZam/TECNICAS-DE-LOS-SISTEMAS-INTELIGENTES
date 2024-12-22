package tracks.singlePlayer.evaluacion.src_ZAMORA_REYES_JOSEANTONIO;
import tools.Vector2d;
import java.util.ArrayList;
import ontology.Types;
import ontology.Types.ACTIONS;
import java.util.Stack;

public class NodoDijkstra implements Comparable<NodoDijkstra>{

	
	
		public int distancia;
		public Vector2d coordenadas;
		public Vector2d orientacion;
		public NodoDijkstra padre;
		public ACTIONS accion;
		public int identificado_nodo;
		
		//Constructor útil para crear los nodos que no son el inicial
		public NodoDijkstra(Vector2d coordenadas, Vector2d orientacion, ACTIONS siguiente_accion, NodoDijkstra nodo_padre) {
			identificado_nodo = identificar(coordenadas,orientacion);
			accion = siguiente_accion;
			this.coordenadas = coordenadas;
			this.orientacion = orientacion;
			distancia =  (int) Double.POSITIVE_INFINITY;
			this.padre = nodo_padre;	
		}
	
		//Constructor útil para crear el nodo inicial
		public NodoDijkstra(Vector2d coordenadas, Vector2d orientacion) {
			identificado_nodo = identificar(coordenadas,orientacion);
			accion = Types.ACTIONS.ACTION_NIL;
			this.coordenadas = coordenadas;
			this.orientacion = orientacion;
			distancia = 0;
			this.padre = null;	
		}
		
		//Esta funcion me sirve para saber si el nodo en el que estamos es el portal.
		public boolean esIgual(double x_nodo , double j_nodo) {
		    return (coordenadas.x == x_nodo && coordenadas.y == j_nodo ) ;
		}	
		
		//Esta función es útil para ordenar en la cola con propiedad.
		@Override
		public int compareTo(NodoDijkstra other) {
			return Integer.compare(distancia, other.distancia);
		}
		
		//Funciones necesarias para crear un identificador unico por cada nodo según las coordenadas y la orientación
		private int identificar(Vector2d coordenadas,Vector2d orientacion) {
	        
	        String idString = coordenadas.x + "," + coordenadas.y + "," + orientacion.x + "," + orientacion.y;
	        return idString.hashCode();
	    }
		
		@Override
		public int hashCode() {
			return identificar(coordenadas,orientacion);
		}
		
		//Función que expande nodos siguiendo el orden establecido y utilizando la funcion "AplicarAccion" que se explica a continuación, la cual crea nodos que serán los que introduzcamos en
		//el array que devuelve la función
		public ArrayList<NodoDijkstra>expandirNodosVecinos(){
			ArrayList<NodoDijkstra> ArrayNodos = new ArrayList<>();
			ArrayNodos.add(AplicarAccion(Types.ACTIONS.ACTION_UP));
			ArrayNodos.add(AplicarAccion(Types.ACTIONS.ACTION_DOWN));
			ArrayNodos.add(AplicarAccion(Types.ACTIONS.ACTION_LEFT));
			ArrayNodos.add(AplicarAccion(Types.ACTIONS.ACTION_RIGHT));
			return ArrayNodos;
		}
	
		//Esta funcion le pasamos como argumento una accion.
		//Si le pasamos una accion la cual no podemos realizar sin una rotación previa , esta funcion devolverá un nodo con las mismas coordenadas que el nodo actual pero con la orientación actualizada
		//con orientación actualizada hago referencia a la orientacion que nos permite realizar la accion que le hemos pasado sin tener que hacer una rotacion. 
		//EJ: si pasamos la accion ACTION_UP con orientacion (0,1) , la orientacion actualizada será (0,-1)
		//Si le pasamos una accion la cual podemos realizar sin hacer ninguna rotacion , la funcion devolverá un nodo con las coordenadas resultantes tras hacer el movimiento y con la misma orientacion
		//Ambos nodos tambien le pasamos por argumento la accion y el nodo padre que es el actual , es decir , desde el cual expandimos.
		public NodoDijkstra AplicarAccion(ACTIONS siguiente_accion) {
			
				NodoDijkstra nodo = null;
				Vector2d nueva_orientacion;
				Vector2d nueva_coordenada;
			
		       switch (siguiente_accion) {
		       
	           case ACTION_UP:
	        	   if((orientacion.x == 0 && orientacion.y == 1) || (orientacion.x == 1 && orientacion.y == 0) || (orientacion.x == -1 && orientacion.y == 0)) {
	        		   nueva_orientacion = new Vector2d(0, -1);
	        		   nodo = new NodoDijkstra(this.coordenadas,nueva_orientacion,siguiente_accion, this);
	        	   }
	        	   else{
	        		   nueva_coordenada = new Vector2d(coordenadas.x, coordenadas.y - 1);
	   				   nodo = new NodoDijkstra(nueva_coordenada,this.orientacion,siguiente_accion, this);
	        	   }
	               break;
	               
	           case ACTION_DOWN:
	        	   if((orientacion.x == 0 && orientacion.y == -1) || (orientacion.x == 1 && orientacion.y == 0) || (orientacion.x == -1 && orientacion.y == 0)) {
	        		   nueva_orientacion = new Vector2d(0, 1);
	        		   nodo = new NodoDijkstra(this.coordenadas,nueva_orientacion,siguiente_accion,this);
	        	   }
	        	   else{
	        		   nueva_coordenada = new Vector2d(coordenadas.x, coordenadas.y+1);
	   				   nodo = new NodoDijkstra(nueva_coordenada,this.orientacion,siguiente_accion, this);
	        	   }
	               break;
	               
	           case ACTION_RIGHT:
	        	   if((orientacion.x == 0 && orientacion.y == 1) || (orientacion.x == 0 && orientacion.y == -1) || (orientacion.x == -1 && orientacion.y == 0)) {
	        		   nueva_orientacion = new Vector2d(1, 0);
	        		   nodo = new NodoDijkstra(this.coordenadas,nueva_orientacion,siguiente_accion, this);
	        	   }
	        	   else{
	        		   nueva_coordenada = new Vector2d(coordenadas.x+1, coordenadas.y);
	   				   nodo = new NodoDijkstra(nueva_coordenada,this.orientacion,siguiente_accion, this);
	        	   }
	               break;
	               
	           case ACTION_LEFT:
	        	   if((orientacion.x == 0 && orientacion.y == 1) || (orientacion.x == 1 && orientacion.y == 0) || (orientacion.x == 0 && orientacion.y == -1)) {
	        		   nueva_orientacion = new Vector2d(-1,0);
	        		   nodo = new NodoDijkstra(this.coordenadas,nueva_orientacion,siguiente_accion, this);
	        	   }
	        	   else{
	        		   nueva_coordenada = new Vector2d(coordenadas.x-1, coordenadas.y);
	   				   nodo = new NodoDijkstra(nueva_coordenada,this.orientacion,siguiente_accion, this);
	        	   }
	               break;
	               
	           default:
	        	   break;
	       }
		       
			return nodo;
		}
		
		
		//Esta funcion nos devuelve la ruta que hemos realizado para llegar al nodo ,desde el cual la estamos llamando.
		//Esta simplemente va actualizando padres de nodos , hasta que lleguemos a un nodo el cual no tenga padre esto nos indicará que ya hemos llegado al origen.
		//Devuelve las acciones en una pila ,debido a que esto sera util para poder sacarlas después en orden correcto.
		
		public Stack<ACTIONS> obtenerRuta(){
			Stack<ACTIONS>conjunto_acciones = new Stack<>();
			conjunto_acciones.push(this.accion);
			NodoDijkstra nodoPadre = this.padre;
			while(nodoPadre != null) {
				conjunto_acciones.push(nodoPadre.accion);
				nodoPadre = nodoPadre.padre;
			}
			return conjunto_acciones;
		}
		
		
		
		

		
	
	
}

