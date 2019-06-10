public class GaugeBuilder<B extends GaugeBuilder<B>> {
    private HashMap<String, Property> properties = new HashMap<>();

    public final B skinType(final SkinType TYPE) {
        properties.put("skinType", new SimpleObjectProperty<>(TYPE));
        return (B)this;
    }

    public final B title(final String TITLE) {
        properties.put("title", new SimpleStringProperty(TITLE));
        return (B)this;
    }

    public final Gauge build() { /* [...] */}
}

public class Test {

    public void init() {
Gauge gauge = new GaugeBuilder().skinType(Gauge.SkinType.MODERN)
                                .title("Input")
                                .returnToZero(false)
                                .animated(true)
                                .animationDuration(25)
                                .smoothing(true)
                                .decimals(0)
                                .prefHeight(200)
                                .barColor(Color.CORNFLOWERBLUE)
                                .build();

}