public class recursive {
    static int result = 0;
    public static int prod(int m, int n){
        if (m > 0) {
            m = m - 1;
            result = prod(m, n) + n;
        }
        return result;
    }
    public static void main(String [] args){
        System.out.println(prod(10,10));

    }
}
