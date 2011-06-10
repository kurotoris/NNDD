package org.mineap.nndd.library.sqlite.dao
{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.filesystem.File;
	
	import org.mineap.nndd.library.sqlite.DbAccessHelper;
	import org.mineap.nndd.library.sqlite.Queries;
	import org.mineap.nndd.model.NNDDFile;
	import org.mineap.nndd.model.TagString;

	/**
	 * 
	 * @author shiraminekeisuke
	 * 
	 */
	public class TagStringDao
	{
		
		private static const dao:TagStringDao = new TagStringDao();
		
		private var _stmt:SQLStatement;
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get instance():TagStringDao{
			return dao;
		}
		
		/**
		 * 
		 * 
		 */
		public function TagStringDao()
		{
			if(dao != null){
				throw new ArgumentError("TagStringDaoはインスタンス化できません。");
			}			
		}
		
		/**
		 * 
		 * @param tag
		 * @return 
		 * 
		 */
		public function insertTagString(tag:TagString, transactionEnable:Boolean = true):Boolean{
			try{
				
				if (transactionEnable)
				{
					DbAccessHelper.instance.connection.begin();
				}
				
				this._stmt = new SQLStatement();
				this._stmt.sqlConnection = DbAccessHelper.instance.connection;
				this._stmt.text = Queries.INSERT_TAGSTRING;
				
				this._stmt.parameters[":tag"] = tag.tag;
				
				this._stmt.execute();
				
				if (transactionEnable)
				{
					DbAccessHelper.instance.connection.commit();
				}
				
				return true;
				
			}catch(error:Error){
				if (transactionEnable)
				{
					DbAccessHelper.instance.connection.rollback();
				}
				trace(error.getStackTrace());
			}
			
			return false;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function selectAllTagString():Vector.<TagString>{
			
			var vector:Vector.<TagString> = new Vector.<TagString>();
			
			try{
				
				this._stmt = new SQLStatement();
				this._stmt.sqlConnection = DbAccessHelper.instance.connection;
				this._stmt.text = Queries.SELECT_TAGSTRING_ALL;
				
				this._stmt.execute();
				
				var result:SQLResult = this._stmt.getResult();
				
				if(result == null){
					return vector;
				}
				
				if(result.data == null){
					return vector;
				}
				
				for each(var object:Object in result.data){
					var tagString:TagString = new TagString(object.tag);
					tagString.id = object.id;
					vector.push(tagString);
				}
				
				return vector;
				
			}catch(error:SQLError){
				trace(error.getStackTrace());
			}
			
			return vector;
		}
		
		/**
		 * 
		 * @param id
		 * @return 
		 * 
		 */
		public function selectTagStringById(id:Number):TagString{
			try{
				
				this._stmt = new SQLStatement();
				this._stmt.sqlConnection = DbAccessHelper.instance.connection;
				this._stmt.text = Queries.SELECT_TAGSTRING_BY_ID;
				
				this._stmt.parameters[":id"] = id;
				
				this._stmt.execute();
				
				var result:SQLResult = this._stmt.getResult();
				
				if(result == null){
					return null;
				}
				
				if(result.data == null){
					return null;
				}
				
				if(result.data.length > 0){
					var tagString:TagString = new TagString(result.data[0].tag);
					tagString.id = result.data[0].id;
					return tagString;
				}
				
			}catch(error:SQLError){
				trace(error.getStackTrace());
			}
			
			return null;
		}
		
		/**
		 * 指定されたIDを持つNNDDVideoから参照されているTagStringを返します
		 * @param id
		 * 
		 */
		public function selectTagStringRelatedByVideo(id:Number):Vector.<TagString>{
			
			var vector:Vector.<TagString> = new Vector.<TagString>();
			
			try{
				
				this._stmt = new SQLStatement();
				this._stmt.sqlConnection = DbAccessHelper.instance.connection;
				this._stmt.text = Queries.SELECT_TAGSTRING_RELATED_BY_NNDDVIDEO;
				
				this._stmt.parameters[":videoid"] = id;
				
				this._stmt.execute();
				
				var result:SQLResult = this._stmt.getResult();
				
				if(result == null){
					return vector;
				}
				
				if(result.data == null){
					return vector;
				}
				
				for each(var object:Object in result.data){
					var id:Number = object.id;
					var tag:String = object.tag;
					var tagString:TagString = new TagString(tag);
					tagString.id = id;
					vector.push(tagString);
				}
				
			}catch(error:SQLError){
				trace(error.getStackTrace());
			}
			
			return vector;
		}
		
		/**
		 *  
		 * @param tag
		 * @return 
		 * 
		 */
		public function selectTagStringByTag(tag:String):TagString{
			try{
				
				this._stmt = new SQLStatement();
				this._stmt.sqlConnection = DbAccessHelper.instance.connection;
				this._stmt.text = Queries.SELECT_TAGSTRING_BY_TAG;
				
				this._stmt.parameters[":tag"] = tag;
				
				this._stmt.execute();
				
				var result:SQLResult = this._stmt.getResult();
				
				if(result == null){
					return null;
				}
				
				if(result.data == null){
					return null;
				}
				
				if(result.data.length > 0){
					var tagString:TagString = new TagString(result.data[0].tag);
					tagString.id = result.data[0].id;
					return tagString;
				}
				
			}catch(error:SQLError){
				trace(error.getStackTrace());
			}
			
			return null;
		}
		
		/**
		 * 
		 * @param tag
		 * @return 
		 * 
		 */
		public function updateTagStringById(tag:TagString):Boolean{
			try{
				
				this._stmt = new SQLStatement();
				this._stmt.sqlConnection = DbAccessHelper.instance.connection;
				this._stmt.text = Queries.UPDATE_TAGSTRING;
				
				this._stmt.parameters[":tag"] = tag.tag;
				this._stmt.parameters[":id"] = tag.id;
				
				this._stmt.execute();
				
				return true;
				
			}catch(error:SQLError){
				trace(error.getStackTrace());
			}
			
			return false;
		}
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function deleteTagStringById(id:Number):Boolean{
			try{
				
				this._stmt = new SQLStatement();
				this._stmt.sqlConnection = DbAccessHelper.instance.connection;
				this._stmt.text = Queries.DELETE_TAGSTRING;
				
				this._stmt.parameters[":id"] = id;
				
				this._stmt.execute();
				
				return true;
				
			}catch(error:SQLError){
				trace(error.getStackTrace());
			}
			
			return false;
		}
		
		/**
		 * 
		 * @param file
		 * @param withSubFile
		 * @return 
		 * 
		 */
		public function selectTagStringByNNDDVideoByFile(file:File, 
														 withSubFile:Boolean = true):Vector.<TagString>
		{
			try
			{
				
				var files:Vector.<NNDDFile> = null;
				if(withSubFile){
					files = FileDao.instance.selectFileByFileWithSubFile(file);
				}else{
					files = new Vector.<NNDDFile>();
					file = FileDao.instance.selectFileByFile(file);
					if(file == null){
						return new Vector.<TagString>;
					}
					files.push(file);
				}
				
				var tags:Vector.<TagString> = new Vector.<TagString>;
				for each(var tempFile:NNDDFile in files)
				{
					this._stmt = new SQLStatement();
					this._stmt.sqlConnection = DbAccessHelper.instance.connection;
					this._stmt.text = Queries.SELECT_TAGSTRING_RELATED_BY_NNDDVIDEO_BY_DIR_ID;
					
					this._stmt.parameters[":dirpath_id"] = tempFile.id;
					
					this._stmt.execute();
					
					var result:SQLResult = this._stmt.getResult();
					
					if(result == null){
						continue;
					}
					
					if(result.data == null){
						continue;
					}
					
					if(result.data.length > 0){
						for each(var object:Object in result.data){
							var tagString:TagString = new TagString(object.tag);
							tagString.id = object.id;
							tags.push(tagString);
						}
					}
				}
				
				return tags;
			}
			catch(error:SQLError)
			{
				trace(error.getStackTrace());
			}
			return new Vector.<TagString>;
		}
		
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function dropTable():Boolean{
			try{
				this._stmt = new SQLStatement();
				this._stmt.sqlConnection = DbAccessHelper.instance.connection;
				this._stmt.text = Queries.DROP_TAGSTRING;
				this._stmt.execute();
				return true;
			}catch(error:SQLError){
				trace(error.getStackTrace());
			}
			
			return false;
		}
		
	}
}