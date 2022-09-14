<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat,java.util.Date"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>

<body>

Here are the searched items!
	<%
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		//Create a SQL statement
		Statement stmt = con.createStatement();
		
		//Get parameters from the HTML form at the index.jsp
		int uid =(Integer) session.getAttribute("uid");
		String sql="SELECT * FROM interested where uid = '"+uid+"'";
		
		ResultSet result = stmt.executeQuery(sql);
		String buffer="";
		buffer+="<table>\n";

		while(result.next()){		
			String category = result.getString("category");
			String subcategory = result.getString("subcategory");
			String sql_ = sql = "SELECT * FROM aution WHERE category = '" + category + "' and subcategory = '" + subcategory+"'";
			Statement stmt1 = con.createStatement();
			ResultSet  result_ = stmt1.executeQuery(sql_);	
			while(result_.next()){	
				String image = result_.getString("image");
				String _category = result_.getString("category");
				String _subcategory = result_.getString("subcategory");
				String _description = result_.getString("description");
				int seller_id = result_.getInt("seller_id");
				double original_price= result_.getDouble("original_price");
				double increment= result_.getDouble("increment");
				String start_time= result_.getString("start_time");
				String end_time= result_.getString("end_time");	
				int  aution_id = result_.getInt("aution_id");
				int  max_bid_id = result_.getInt("max_bid_id");
				double max_bid_price = result_.getDouble("max_bid_price");
				double minprice = result_.getDouble("minprice");
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");			
				Date now_time = sdf.parse(sdf.format(new Date()));
				String jieshu="";
				int max_buyer_id = 0;
				String sql_1 = "SELECT * FROM bid WHERE aution_id = '" + aution_id+"' and bid_id='"+max_bid_id+"'";
				Statement stmt2 = con.createStatement();
				ResultSet  result_1 = stmt2.executeQuery(sql_1);	
				if(result_1.next()){
					max_buyer_id = result_1.getInt("buyer_id");		
				}
				if(now_time.after(sdf.parse(end_time))){
					jieshu += "the aution is over.<br>";
					if(max_bid_id!=-1&&minprice<=max_bid_price){
						jieshu+=String.format("knock down price:%s<br>",max_bid_price);
						jieshu += String.format("<a href='user.jsp?user_id=%d'>winner's HomePage</a>\n",max_buyer_id);
					
					}
				}else if(max_bid_id!=-1){
					jieshu += String.format("<a href='user.jsp?user_id=%d'>The buyer given the highest price till now's HomePage</a>",max_buyer_id);
				}
			 buffer+=	String.format(	
					"<tr><td>\n"+
					"<form  method = 'post'  >\n"+		
					"<br>"+
					"<img src='%s' width='120', height='80' />\n"+
					"<br>"+				
					"category:%s\t\t\t subcategory:%s\n"+
					"<br>"+			
					"description:%s\n"+
					"<br>"+			
					"original price:%.2f\t\t\t now max bid price:%.2f\n"+
					"<br>"+			
					"start_time:%s\t\t\t end_time:%s\n"+	
					"<br>"+	
					"%s<br>"+	
					"</form>\n"+
					"<a href='user.jsp?user_id=%d'>seller's HomePage</a>\n"+
					"<br>"+	
					"<a href='Bidding_historys.jsp?aution_id=%d'>Bidding historys</a>\n"+
					"<br>"+	
					"<a href='Release_bid.jsp?aution_id=%d'>Make a Bid</a>\n"
					,
					image,_category,_subcategory,_description,original_price,max_bid_price,start_time,end_time,jieshu,seller_id,aution_id,aution_id);  
			
	 			buffer+=String.format(		
								"<br>"+		
								"------------------------------------------------------------\n"+
								"<br>"+	
								"</td></tr>\n");
	 		}
		}
		buffer+="</table>\n";
		out.println(buffer);
	
		
		//close the connection.
		con.close();
		out.print("Search interested autions succeeded");
	} catch (Exception ex) {
		out.print(ex);
		out.print("Search interested autions  failed");
	}
	
%>
<br>
<a href="javascript:history.back(-1)">reutrn</a>
</body>
</html>