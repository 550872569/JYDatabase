# JYDatabase
对FMDB的轻量级封装，帮助快速创建管理移动端数据库。让SQLite使用更加简单

要实现的目标：

	1.自动处理数据库升级，让使用者不用考虑数据库升级带来烦劳。
	2.封装简单常用的查询语句，让使用者只用关注特殊的SQL查询，基本查询不用重复写直接使用即可。

一、JYDatabase 的使用
![enter image description here](http://imgdata.hoop8.com/1605/2283412352730.jpg)

	如图：是Demo中创建本地数据库的一个框图。
	BS1: JYDBService类 提供了所有对外的查询方法，数据库的增删查改都通过这个单利调用。
	BS2: JYPersonDB 是JYDBService 所包含的其中一个数据库，他管理着 该库所有表的创建和升级。
	BS3: JYPersonTable 是JYPersonDB库下的其中一张表，它管理了该表的所有 增删查改 操作。
	BS4: JYPersonInfo 是映射JYPersonTable表的列的对象。JYPersonTable表查询出来的数据都会转换成JYPersonInfo对象。
	注意：个人建议不要在项目中建多个数据库，建一个数据库，多张表即可。

1.1 JYPersonTable建立（数据表）
	
	数据表的建立需要继承 JYContentTable(该类实现了工作中用到的大部分SQL查询)，只要重写以下几个方法就可以快速创建一张数据表。
	
	  // 必须实现 contentClass 是该表所对应的模型类，tableName 是表的名字
	  - (void)configTableName{             
         self.contentClass = [JYPersonInfo class];
         self.tableName = @"JYPersonTable";
      }
      
	  // 必须实现 contentId 是该表的主键（也是唯一索引）比如用户的userId 必须是 contentClass 的属性
      - (NSString *)contentId{
          return @"personnumber";
      }

	  // 数据表的其他字段，必须是 contentClass 的属性，如不实现则默认取 contentClass 以“DB”结尾 的属性
      - (NSArray<NSString *> *)getContentField{
          return @[@"mutableString1",@"integer1",@"uInteger1",@"int1",@"bool1",@"double1"];
      }

	  // 表创建时对应字段的默认长度，如不写，取默认。
      - (NSDictionary*)fieldLenght{
      	  return @[@"mutableString1":@"512"];
      }
      
      // 查询是否使用NSCache缓存，默认YES。
      - (BOOL)enableCache{
          return NO;
      }
      
      注意：1.数据表映射的属性仅仅支持 NSString  NSMutableString  NSInteger NSUInteger int BOOL double float的数据类型考虑到 NSData使用场景不多，且不建议向数据库存入NSData 故暂时不支持。
      其在数据表中对应的是@"BOOL",@"DOUBLE",@"FLOAT",@"INTEGER",@"INTEGER",@"INTEGER",@"VARCHAR",@"VARCHAR"
      默认的数据长度是   @"1"   ,@"10"    ,@"10"   ,@"10"     ,@"10"     ,@"10"     ,@"128"    ,@"128"
      
      2.NSCache的默认缓存条数是20条，可自行设置修改self.cache.countLimit = 20; 使用enableCache 将优先从缓存中取数据
      如自行实现的查询请在适当情况下使用以下三个方法来加入缓存。方法内部有 enableCache 的实现。
      - (id)getCacheContentID:(NSString *)aID;
	  - (void)saveCacheContent:(id)aContent;
	  - (void)removeCacheContentID:(NSString *)aID;
      
  1.2 JYPersonDB管理了数据库的创建和升级 需要继承JYDataBase

	关键方法：
	// 该方法会根据当前版本判断 是创建数据库表还是 数据表升级
	- (void)buildWithPath:(NSString *)aPath mode:(ArtDatabaseMode)aMode;
	
	// 返回当前数据库版本，只要数据表有修改 返回版本号请 ＋1
	- (NSInteger)getCurrentDBVersion{
	    return 4;
	}
	
	// 所有数据表的创建请在该方法实现  调用固定方法 - (void)createTable:(FMDatabase *)aDB;
	- (void)createAllTable:(FMDatabase *)aDB{
	    [self.personTable createTable:aDB];
	}
	
	// 所有数据表的升级请在该方法实现  调用固定方法 - (void)insertDefaultData:(FMDatabase *)aDb;
	- (void)updateDB:(FMDatabase *)aDB{
	    [self.personTable updateDB:aDB];
	}

  1.3 JYDBService
  
  	这是一个单例，向外提供数据库的一切外部接口，具体实现大家可以看Demo。
  	
  	
 二、内部部分代码的实现讲解
 
 2.1 数据库升级的实现 - (void)updateDB:(FMDatabase *)aDB 
 
 	考虑到
  	
  	
      
      