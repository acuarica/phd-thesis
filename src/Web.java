
public class Web {

    private static <T> T create(Class<?> cls) throws InstantiationException, IllegalAccessException {
        return (T) cls.newInstance();
    }

    public static void main(String[] args) throws InstantiationException, IllegalAccessException {
        Web o = create(String.class);
        System.out.println(o);
    }

}