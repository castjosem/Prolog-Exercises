
public class Objeto {
    private int id;
    private int x;
    private int y;
    private String tipo;
    private String atributo;
    private String valor;

    public Objeto (){
    }

    public Objeto(int id, int x, int y, String tipo, String atributo, String valor)
    {
        this.id = id;
        this.x = x;
        this.y = y;
        this.tipo= tipo;
        this.atributo = atributo;
        this.valor = valor;
    }

    public int getId() {
        return id;
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

    public String getTipo() {
        return tipo;
    }

    public String getAtributo() {
        return atributo;
    }

    public String getValor() {
        return valor;
    }

}
