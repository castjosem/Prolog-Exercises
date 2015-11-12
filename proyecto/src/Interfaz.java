
import java.awt.Color;
import java.awt.GridLayout;
import java.awt.event.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JPanel;


public class Interfaz extends javax.swing.JFrame implements MouseListener{

    private int tamaño;
    private JPanel[][] ambiente_ui;
    private Ambiente amb;

    public Interfaz(int tamaño) {
        initComponents();
        this.setExtendedState(this.getExtendedState() | Interfaz.MAXIMIZED_BOTH);
        this.tamaño = tamaño;
        ambiente_ui = new JPanel[tamaño][tamaño];
        Tablero.setLayout(new GridLayout(this.tamaño,this.tamaño));
        drawBoard();
        setVisible(true);
    }
    @SuppressWarnings("unchecked")
    private void initComponents() {

        Controles = new javax.swing.JPanel();
        jScrollPane1 = new javax.swing.JScrollPane();
        TEXTAREA = new javax.swing.JTextArea();
        Ambiente_Panel = new javax.swing.JPanel();
        Tablero = new javax.swing.JPanel();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        Controles.setBorder(javax.swing.BorderFactory.createTitledBorder("Controles"));

        TEXTAREA.setColumns(20);
        TEXTAREA.setEditable(false);
        TEXTAREA.setFont(new java.awt.Font("Courier New", 0, 11)); // NOI18N
        TEXTAREA.setRows(5);
        TEXTAREA.setFocusable(false);
        jScrollPane1.setViewportView(TEXTAREA);

        javax.swing.GroupLayout ControlesLayout = new javax.swing.GroupLayout(Controles);
        Controles.setLayout(ControlesLayout);
        ControlesLayout.setHorizontalGroup(
            ControlesLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(ControlesLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 166, Short.MAX_VALUE)
                .addContainerGap())
        );
        ControlesLayout.setVerticalGroup(
            ControlesLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(ControlesLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 88, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(179, Short.MAX_VALUE))
        );

        Ambiente_Panel.setBorder(javax.swing.BorderFactory.createTitledBorder("Ambiente"));
        Ambiente_Panel.setFocusable(false);

        Tablero.setFocusable(false);

        javax.swing.GroupLayout TableroLayout = new javax.swing.GroupLayout(Tablero);
        Tablero.setLayout(TableroLayout);
        TableroLayout.setHorizontalGroup(
            TableroLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 255, Short.MAX_VALUE)
        );
        TableroLayout.setVerticalGroup(
            TableroLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 278, Short.MAX_VALUE)
        );

        javax.swing.GroupLayout Ambiente_PanelLayout = new javax.swing.GroupLayout(Ambiente_Panel);
        Ambiente_Panel.setLayout(Ambiente_PanelLayout);
        Ambiente_PanelLayout.setHorizontalGroup(
            Ambiente_PanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(Tablero, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        Ambiente_PanelLayout.setVerticalGroup(
            Ambiente_PanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(Tablero, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(Controles, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(Ambiente_Panel, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(Controles, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(Ambiente_Panel, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JPanel Ambiente_Panel;
    private javax.swing.JPanel Controles;
    private javax.swing.JTextArea TEXTAREA;
    private javax.swing.JPanel Tablero;
    private javax.swing.JScrollPane jScrollPane1;
    // End of variables declaration//GEN-END:variables

    public void mouseEntered(MouseEvent e){}
    public void mouseReleased(MouseEvent e){}
    public void mouseExited(MouseEvent e){}
    public void mousePressed(MouseEvent e){}
    public void mouseClicked(MouseEvent e) {}

    private void drawBoard() {        
        for (int i = 0; i < tamaño; i++)
            for (int j = 0; j < tamaño; j++)
            {
                ambiente_ui[i][j] = new JPanel();
                ambiente_ui[i][j].addMouseListener(this);
                ambiente_ui[i][j].setBackground(Color.PINK);
                ambiente_ui[i][j].setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(0, 0, 0), 1));
                Tablero.add(ambiente_ui[i][j]);    
            }
    }

    public void run()
    {
        try {
            amb = new Ambiente(tamaño, ambiente_ui, Tablero);
        } catch (InterruptedException ex) {
            Logger.getLogger(Interfaz.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
