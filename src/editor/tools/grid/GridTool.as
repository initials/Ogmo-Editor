package editor.tools.grid 
{
	import editor.GridLayer;
	import editor.Layer;
	import editor.tools.Tool;
	
	
	public class GridTool extends Tool
	{
		protected var gridLayer:GridLayer
		
		public function GridTool(layer:Layer) 
		{
			super(layer);
			gridLayer = layer as GridLayer;
		}
		
		
		/**
		 * Returns the current level as an array (matrix)
		 *
		 * @return a multi-dimensional array of the current level
		 */	
		public function getCurrentLevel():Array
		{
			var currentLevel:Array = new Array();
			for ( var y:uint = 0; y < gridLayer.width / gridLayer.gridSize; ++y )
			{
				currentLevel.push( new Array );
				for ( var x:uint = 0; x < gridLayer.height / gridLayer.gridSize; ++x ) {
					if (gridLayer.grid.getCell(x, y))
						currentLevel[y].push(1);
					else if (!gridLayer.grid.getCell(x, y))
						currentLevel[y].push(0);
				}
			}
			return currentLevel;
				
		}
		
	}

}