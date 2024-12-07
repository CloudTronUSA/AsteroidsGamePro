// bullet class

class Bullet extends Entity {
	private double[] movement;

	public Bullet(Player player) {
		super(
            player.getTransform().x, player.getTransform().y, // pos
            16, 44, // size
            player.getTransform().rotation,   // rotation
            "assets/images/game_effect_bullet.png",  // image path
            20,  // speed
            1,    // max health
            player.getDamage()  // damage
        );
		
		double movementPerTickX = sin(radians((float)transform.rotation));
		double movementPerTickY = -1 * cos(radians((float)transform.rotation));
        movement = new double[] {movementPerTickX, movementPerTickY};
	}

	public void update() {
        move(movement[0], movement[1], false);
        super.draw();
    }
}