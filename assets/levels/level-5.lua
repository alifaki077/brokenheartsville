return {
	meta = {
		_next = "assets/levels/level-6.lua",
		pause = false,
		info = "LEVEL 5\nSTAY UP"
	},
	blocks = {
		{x = 250, y = 200},
		{x = 250 + 64, y = 200},
		{x = 250 + 2 * 64, y = 200},
		{x = 250 + 3 * 64, y = 200},
		{x = 250 + 4 * 64, y = 200},
		{x = 250 + 5 * 64, y = 200},
		{x = 250 + 6 * 64, y = 200},
		{x = 250 + 7 * 64, y = 200},
		{x = 250 + 8 * 64, y = 200},
	},

	broken = {
		{x = 230 + 32, y = 150 - 36},
		{x = 530 + 64, y = 150 - 36},
		{x = 830 + 64, y = 150 - 36},

	},

	platforms = {
		{x = 230, y = 150},
		{x = 230 + 32, y = 150},
		{x = 230 + 32, y = 150},
		{x = 230 + 64, y = 150},
		{x = 230 + 64 + 32, y = 150},
		{x = 230 + 64 + 64, y = 150},

		{x = 530, y = 150},
		{x = 530 + 32, y = 150},
		{x = 530 + 32, y = 150},
		{x = 530 + 64, y = 150},
		{x = 530 + 64 + 32, y = 150},
		{x = 530 + 64 + 64, y = 150},

		{x = 830, y = 150},
		{x = 830 + 32, y = 150},
		{x = 830 + 32, y = 150},
		{x = 830 + 64, y = 150},
		{x = 830 + 64 + 32, y = 150},
		{x = 830 + 64 + 64, y = 150}
	}
}
