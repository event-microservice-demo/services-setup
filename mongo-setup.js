conn = new Mongo();
db = conn.getDB("testjobs");

printjson(db.getCollectionNames())
