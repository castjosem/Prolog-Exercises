
import java.awt.Color;
import java.util.ArrayList;
import java.util.Random;
import javax.swing.JOptionPane;
import javax.swing.JPanel;

public class Agente extends Thread {
    private ArrayList<Objeto> conocimiento;
    private int x;
    private int y;
    private int v;
    private int pasos;
    private Random rand;
    private int dir;
    private int aux_nuevo_x;
    private int aux_nuevo_y;
    private Object[][] tablero;
    private JPanel[][] ambiente_ui;

    public Agente(int x, int y, int v, Object[][] tablero, JPanel[][] ambiente_ui){
        this.x = x;
        this.y = y;
        rand = new Random();
        pasos = 0;
        this.v = v;
        conocimiento = new ArrayList<Objeto>();
        this.tablero = tablero;
        this.ambiente_ui = ambiente_ui;
    }
    
    public synchronized void ver(Object[][] tablero){
        // limO = Límite por el Oeste
        // limE = Límite por el Este
        // limN = Límite por el Norte
        // limS = Límite por el Sur
        
        // Cálculo de los límites para asegurar que la matriz visión del agente esté dentro de la matríz ambiente
        int limO = this.y-( (this.v-1)/2 );
        if (limO < 0) limO = 0;
        int limE = this.y+( (this.v-1)/2 );
        if (limE > tablero.length-1) limE = tablero.length-1;
        int limN = this.x-( (this.v-1)/2 );
        if (limN < 0) limN = 0;
        int limS = this.x+( (this.v-1)/2 );
        if (limS > tablero.length-1) limS = tablero.length-1;

        for (int i=limN; i<=limS; i++){
            for (int j=limO; j<=limE; j++){
                    if (tablero[i][j] != null && !tablero[i][j].getClass().getName().equals("Agente")){
                        if (tablero[i][j].getClass().getName().equals("Objeto")) {
                            if (  !conocimiento.contains((Objeto) tablero[i][j]) )
                                conocimiento.add((Objeto) tablero[i][j]);
                        } 
                        
                    }
            }
        }
    }

    public ArrayList<Objeto> getConocimiento() {
        return conocimiento;
    }

    public synchronized void deambular(){
        ver(tablero);
        if(pasos == 0)
        {
            pasos = rand.nextInt(15)+1;
            dir = rand.nextInt(8);
        }
        paso();
    }
    
    public synchronized void paso(){
        aux_nuevo_x = x+Coordenadas.dx[dir];
        aux_nuevo_y = y+Coordenadas.dy[dir];
        if(adentro(aux_nuevo_x,aux_nuevo_y,tablero.length)&& (tablero[aux_nuevo_x][aux_nuevo_y]==null))
        {
            tablero[aux_nuevo_x][aux_nuevo_y] = tablero[x][y];
            tablero[x][y] = null;
            ambiente_ui[aux_nuevo_x][aux_nuevo_y].setBackground(Color.RED);
            ambiente_ui[x][y].setBackground(Color.PINK);

            x=aux_nuevo_x;
            y=aux_nuevo_y;
            pasos--;
        }
        else
            pasos=0;
    }
    public int getX() {
        return x;
    }
    public void setX(int x) {
        this.x = x;
    }
    public int getY() {
        return y;
    }
    public void setY(int y) {
        this.y = y;
    }
    private boolean adentro(int x, int y, int tamaño)
    {
        return (x>0 && x<tamaño && y>0 && y<tamaño);
    }

    @Override
    public void run() {
        while (true){
            deambular();
            try {
                Thread.sleep(100);
            } catch (InterruptedException ex) {
                JOptionPane.showMessageDialog(new JPanel(), "Explotó.", "OMG", JOptionPane.PLAIN_MESSAGE);
            }
        }
    }
}
