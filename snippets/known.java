public class DebugConnection {

    protected void hookServerLaunch() {
        debugTarget = (PHPDebugTarget) createDebugTarget(/* [...] */);
    }

    protected IDebugTarget createDebugTarget(/* [...] */) {
        return new PHPDebugTarget(/* [...] */);
    }

}