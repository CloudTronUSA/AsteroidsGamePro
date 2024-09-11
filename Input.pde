class Input {
	public double xAxis;
	public double yAxis;
	
	public Input() {
		xAxis = 0;
		yAxis = 0;
	}
	
	public void onKeyPressed() {
		//println('pressed!');
		if (key == 'w')
			yAxis = 1;
		if (key == 's')
			yAxis = -1;
		if (key == 'd')
			xAxis = 1;
		if (key == 'a')
			xAxis = -1;
	}
	
	public void onKeyReleased() {
		//println('released!');
		if ((key == 'w' || key == 's') && yAxis != 0)
			yAxis = 0;
		if ((key == 'd' || key == 'a') && xAxis != 0)
			xAxis = 0;
	}
}