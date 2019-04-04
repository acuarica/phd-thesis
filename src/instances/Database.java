package instances;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

// https://lgtm.com/projects/g/openrocket/openrocket/snapshot/dist-1799200383-1524814812150/files/core/src/net/sf/openrocket/database/Database.java?sort=name&dir=ASC&mode=heatmap#L89
public class Database<T extends Comparable<T>> {

    private final ArrayList<DatabaseListener<T>> listeners = new ArrayList<DatabaseListener<T>>();

    @SuppressWarnings("unchecked")
    protected void fireAddEvent(T element) {
        Object[] array = listeners.toArray();
        for (Object l : array) {
            ((DatabaseListener<T>) l).elementAdded(element, this);
        }
    }

    /**
     * Refactored method without casting, but without calling the
     * <code>toArray</code> method.
     * 
     * @param element
     */
    protected void fireAddEvent0(T element) {
        for (DatabaseListener<T> l : listeners) {
            l.elementAdded(element, this);
        }
    }

    protected void fireAddEvent1(T element) {
        DatabaseListener<T>[] array = (DatabaseListener<T>[]) listeners.toArray();
        for (DatabaseListener<T> l : array) {
            l.elementAdded(element, this);
        }
    }
}

interface DatabaseListener<T extends Comparable<T>> {
    public void elementAdded(T element, Database<T> source);

    public void elementRemoved(T element, Database<T> source);
}

class SnippetUncheckedCast {
    @SuppressWarnings("unchecked")
    public static void main(String[] args) {
        ArrayList<String> xs = new ArrayList<String>();
        ArrayList<Number> ns = (ArrayList<Number>) (Object) xs;
        xs.add("Hello");
        Number s = ns.get(0);
        System.out.println(s);
    }
}

class SnippetArraySubtyping {
    public static void main(String[] args) {
        List<Integer> xs = Arrays.asList(1, 2, 3);
        System.out.println(xs);
        Integer[] is = (Integer[]) xs.toArray();
        System.out.println(is);
    }
}

class SnippetGenericArray {
    public static void main(String[] args) {
        List<Number>[] ls = new List[10];
        for (int i = 0; i < ls.length; i++) {
            ls[i] = new ArrayList<Number>();
        }
        System.out.println(ls);
        for (int i = 0; i < ls.length; i++) {
            System.out.println(ls[i]);
        }
    }
}
