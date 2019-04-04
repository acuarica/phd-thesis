package instances;

import java.util.ArrayList;
import java.util.List;

// https://lgtm.com/projects/g/ppiastucki/recast4j/snapshot/dist-4860452-1524814812150/files/detourtilecache/src/main/java/org/recast4j/detour/tilecache/AbstractTileLayersBuilder.java?sort=name&dir=ASC&mode=heatmap#L50
public class AbstractTileLayersBuilder {

    /**
     * 
     * https://www.simplexacode.ch/en/blog/2018/08/the-problem-with-creating-generic-arrays/
     * 
     * @param n
     * @return
     */
    List<byte[]> buildMultiThread(int n) {
        List<?>[] partialResults = new List[n];
        for (int i = 0; i < n; ++i) {
            partialResults[i] = build(i);
        }
        List<byte[]> layers = new ArrayList<>();
        for (int i = 0; i < n; ++i) {
            layers.addAll((List<byte[]>) partialResults[i]);
        }
        return layers;
    }

    List<byte[]> buildMultiThread0(int n) {
        // Compile-time error: Cannot create a generic array of List<byte[]>
        // List<byte[]>[] partialResults = new List<byte[]>[n];
        List<byte[]>[] partialResults = new List[n];
        for (int i = 0; i < n; ++i) {
            partialResults[i] = build(i);
        }
        List<byte[]> layers = new ArrayList<>();
        for (int i = 0; i < n; ++i) {
            layers.addAll(partialResults[i]);
        }
        return layers;
    }

    protected List<byte[]> build(int i) {
        return null;
    }

}