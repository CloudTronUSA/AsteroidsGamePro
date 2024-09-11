class Bullet extends Floater {
	public double speed = 24;

	private double movementPerTickX;
	private double movementPerTickY;

	public Bullet(Player player) {
		super(player.posX, player.posY, 16, 44, player.direction, player.direction, "data/game_effect_bullet.png")
		
		movementPerTickX = speed * sin(radians(super.direction));
		movementPerTickY = -speed * cos(radians(super.direction));
	}
	
	public void updateBullet() {
		super.fTranslate(movementPerTickX, movementPerTickY, false);
		
		super.update();
	}
}