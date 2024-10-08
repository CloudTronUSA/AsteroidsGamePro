class Input {
	public double xAxis = 0;
	public double yAxis = 0;
	public boolean fire = false;
	
	public boolean isLeft = false;
	public boolean isRight = false;
	public boolean isUp = false;
	public boolean isDown = false;
	
	public Input() {
	}

	public void updateInput() {
		xAxis = 0;
		yAxis = 0;
		if (isUp)
			yAxis = 1;
		if (isDown)
			yAxis = -1;
		if (isLeft)
			xAxis = 1;
		if (isRight)
			xAxis = -1;
	}
	
	public void onKeyPressed() {
		//println('pressed!');
		if (key == 'w')
			isUp = true;
		if (key == 's')
			isDown = true;
		if (key == 'd')
			isLeft = true;
		if (key == 'a')
			isRight = true;
		if (keyCode == 32)
			fire = true;
	}
	
	public void onKeyReleased() {
		//println('released!');
		if (key == 'w')
			isUp = false;
		if (key == 's')
			isDown = false;
		if (key == 'd')
			isLeft = false;
		if (key == 'a')
			isRight = false;
		if (keyCode == 32)
			fire = false;
	}
}