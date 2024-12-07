// Animation Controller

class AnimController {
    private ArrayList<Keyframe> keyframes;
    private int currentKeyframeIndex;
    private int currentFrames;
    private boolean loop;

    public AnimController() {
        keyframes = new ArrayList<Keyframe>();
        currentKeyframeIndex = 0;
        currentFrames = 0;
        loop = false;
    }

    public void addKeyframe(Keyframe keyframe) {
        keyframes.add(keyframe);
    }

    // add multiple keyframes
    public void addKeyframes(Keyframe[] keyframes) {
        for (int i = 0; i < keyframes.length; i++) {
            this.keyframes.add(keyframes[i]);
        }
    }

    public void update() {
        if (keyframes.size() == 0) {
            return;
        }

        // check if the animation has finished and loop is false
        if (hasFinished()) {
            return;
        }

        // loop is true, reset the animation
        if (currentKeyframeIndex == keyframes.size()) {
            currentKeyframeIndex = 0;
            currentFrames = 0;
        }

        Keyframe currentKeyframe = keyframes.get(currentKeyframeIndex);
        Keyframe nextKeyframe = keyframes.get(currentKeyframeIndex + 1);

        // determine the current keyframe
        if (currentFrames == nextKeyframe.framestamp) {
            currentKeyframeIndex += 1;
            currentKeyframe = keyframes.get(currentKeyframeIndex);
            if (currentKeyframeIndex == keyframes.size() - 1) {
                nextKeyframe = currentKeyframe;
            } else {
                nextKeyframe = keyframes.get(currentKeyframeIndex + 1);
            }
        }

        int currentKeyframeFrames = Math.max(1, currentFrames - currentKeyframe.framestamp);

        float t = (float)currentKeyframeFrames / Math.max(1, (nextKeyframe.framestamp - currentKeyframe.framestamp));    // how much time has passed between the two keyframes
        float x = lerp((float)currentKeyframe.x, (float)nextKeyframe.x, t);
        float y = lerp((float)currentKeyframe.y, (float)nextKeyframe.y, t);
        int sizeX = (int) lerp(currentKeyframe.sizeX, nextKeyframe.sizeX, t);
        int sizeY = (int) lerp(currentKeyframe.sizeY, nextKeyframe.sizeY, t);
        float rotation = lerp((float)currentKeyframe.rotation, (float)nextKeyframe.rotation, t);

        // apply the transformation
        Transform newTransform = currentKeyframe.sprite.getTransform();
        newTransform.x = x;
        newTransform.y = y;
        newTransform.w = sizeX;
        newTransform.h = sizeY;
        newTransform.rotation = rotation;
        currentKeyframe.sprite.setTransform(newTransform);

        currentFrames += 1;
    }

    public void setLoop(boolean loop) {
        this.loop = loop;
    }

    public boolean hasFinished() {
        return !loop && currentFrames > keyframes.get(keyframes.size() - 1).framestamp;
    }
}

class Keyframe {
    public Sprite sprite;
    public double x, y;  // position
    public int sizeX, sizeY;  // size
    public double rotation;  // rotation
    public int framestamp;  // frame timestamp (this is the # of FRAMES)

    public Keyframe(Sprite sprite, double x, double y, int sizeX, int sizeY, double rotation, int framestamp) {
        this.sprite = sprite;
        this.x = x;
        this.y = y;
        this.sizeX = sizeX;
        this.sizeY = sizeY;
        this.rotation = rotation;
        this.framestamp = framestamp;
    }
}
