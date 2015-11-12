
import java.awt.Color;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Scanner;
import javax.swing.JOptionPane;
import javax.swing.JPanel;

public class Ambiente {
    private Object[][] tablero;
    private ArrayList<Agente> agentes;
    private ArrayList<Objeto> objetos;

    public Ambiente(int tamaño, JPanel[][] ambiente_ui, JPanel Tablero) throws InterruptedException {
        tablero = new Object[tamaño][tamaño];
        agentes = new ArrayList<Agente>();
        objetos = new ArrayList<Objeto>();

        try {
            Lectura(ambiente_ui);
            for(int i=0 ; i<agentes.size(); i++){
                agentes.get(i).start();
            }
        } catch (FileNotFoundException ex) {
            JOptionPane.showMessageDialog(new JPanel(), "No se pudo encontrar el archivo de entrada.", "ERROR", JOptionPane.ERROR_MESSAGE);
        }
        System.out.println("Prueba");
        escribir();
    }

    public Object getTablero(int i, int j) {
        return tablero[i][j];
    }
    
    private void Lectura(JPanel[][] ambiente_ui) throws FileNotFoundException{
        FileReader archivo = new FileReader("entrada.txt");
        Scanner scan = new Scanner(archivo);
        int cant_agentes = scan.nextInt();
        for(int i=0 ; i<cant_agentes ; i++){
            Agente nuevo_agente = new Agente(scan.nextInt(),scan.nextInt(), 9, tablero, ambiente_ui);
            agentes.add(nuevo_agente);
            tablero[nuevo_agente.getX()][nuevo_agente.getY()] = nuevo_agente;
            ambiente_ui[nuevo_agente.getX()][nuevo_agente.getY()].setBackground(Color.RED);
        }
        int cant_objetos = scan.nextInt();
        for(int i=0 ; i<cant_objetos ; i++){
            Objeto nuevo_objeto = new Objeto(i,scan.nextInt(),scan.nextInt(),scan.next(), null, null);
            objetos.add(nuevo_objeto);
            tablero[nuevo_objeto.getX()][nuevo_objeto.getY()] = nuevo_objeto;
            ambiente_ui[nuevo_objeto.getX()][nuevo_objeto.getY()].setBackground(Color.BLUE);
        }
    }

    private void escribir(){
        for(int i=0 ; i<agentes.size(); i++)
        {
            try
            {
                FileWriter fstream = new FileWriter("Agente "+(i+1)+".pl");
                PrintWriter out = new PrintWriter(fstream);
                System.out.print("ESCRIBIENDO EN EL ARCHIVO EL AGENTE = " + (i+1) + ":" + agentes.get(i).getConocimiento() + "\n");
                out.println("%<Objetos reconocidos por el agente> ");
                out.println("% ID(s) de Objeto(s):"+agentes.get(i).getConocimiento());
                for (int k = 0; k< agentes.get(i).getConocimiento().size(); k++ )
                {
                    // agentes.get(i).getConocimiento().get(X) con esta linea me devolvera lo que contiene el arreglo de conocimiento del agente.
                    out.println("%  Objeto(s) tipo:"+agentes.get(i).getConocimiento().get(k).getTipo());
                    out.println("%  Objeto(s) atributo:"+agentes.get(i).getConocimiento().get(k).getAtributo());
                    out.println("%  Objeto(s) relacion:"+agentes.get(i).getConocimiento().get(k).getValor());
                    out.println(agentes.get(i).getConocimiento().get(k).getAtributo()+"("+agentes.get(i).getConocimiento().get(k).getTipo()+","+agentes.get(i).getConocimiento().get(k).getValor()+").");
                }

                out.close();

               }
             catch (Exception e){
                 System.err.println("Error: " + e.getMessage());
             }
        }
    }


}
