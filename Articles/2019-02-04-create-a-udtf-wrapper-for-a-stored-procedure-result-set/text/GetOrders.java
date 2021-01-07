import com.ibm.db2.app.*;
import java.sql.*;
import java.math.BigDecimal;

/*
  Class:  GetOrders
 
  Author: Michael Sansoterra

  Date:   2018-12-18

  COMPILE NOTES (from inside QSHELL (QSH)):

  The class file for the routine must be placed in 
  "/qibm/userdata/os400/sqllib/function"
 
  javac -d /qibm/userdata/os400/sqllib/function /mysourcefolder/GetOrders.java
  



  POTENTIAL ERROR:
  Program may not run properly in interactive SQL (STRSQL) when
  job's CCSID is set to 65535.  Set job's CCSID to 37 (US EBCDIC) or your preferred CCSID.

  Function registration with DB2:

CREATE OR REPLACE FUNCTION GetOrdersJava (@CustomerID INT)
RETURNS TABLE (
SalesOrderId INT,
CustomerId   INT,
OrderDate    DATE,
ShipDate     DATE,
SUBTOTAL     DEC(19,4))
EXTERNAL NAME 'GetOrders.orders'
LANGUAGE JAVA
PARAMETER STYLE DB2GENERAL
DISALLOW PARALLEL
FENCED
SCRATCHPAD 
FINAL CALL 
RETURNS NULL ON NULL INPUT
MODIFIES SQL DATA

*/

public class GetOrders extends UDF {
  Connection connection;
  Statement  stmt;
  ResultSet  rs;

  // This method will be invoked by DB Manager
  public void orders(
    
    // input parameter(s)

    int parmCustomerId,

    // output columns

    int salesOrderId,
    int customerId,
    String orderDate, 
    String shippedDate, 
    BigDecimal subTotal
    ) throws Exception {


    // getCallType() method controls program flow

    int callType=getCallType();
    switch(callType) {

      // SQLUDF_TF_FIRST
      // invoked if UDTF definition has FINAL CALL specified 
      case SQLUDF_TF_FIRST:

        // Verify the SQL Server JDBC driver is available
        // if not, verify the sqlj.install_jar has been
        // done properly.
        try {
          connection = DriverManager.getConnection("jdbc:default:connection");
        }
        catch (Exception e) {
          setSQLstate("38I01");
          setSQLmessage(e.getMessage());
        }
        break;

      // SQLUDF_TF_OPEN
      // invoked only once -- initialization goes here
      case SQLUDF_TF_OPEN:
        try {
          stmt = connection.createStatement();
        }
        catch (Exception e) {
          setSQLstate("38I02");
          setSQLmessage(e.getMessage());
        }

        try {
          String sql="CALL GetOrders (" + parmCustomerId + ")";
          rs = stmt.executeQuery(sql);
        }
        catch (Exception e) {
          stmt.close();
          connection.close();
          setSQLstate("38I03");
          setSQLmessage(e.getMessage());
        }
        break;

      // SQLUDF_TF_FETCH
      // invoked one or more times until SQL State is set
      // to NO DATA ("02000")
      case SQLUDF_TF_FETCH:
        if (rs.next()) {

          // set() method returns data
          // for a given UDTF output column.
          // If set() isn't called for a column,
          // the column will be NULL.

          // For primitive data types, the
          // NULL test must be done manually
          // using the wasNull() method of
          // the ResultSet() class.


          salesOrderId=rs.getInt("SalesOrderId");
          set(2, salesOrderId);

          customerId=rs.getInt("CustomerId");
          set(3, customerId);

          if (rs.getDate("OrderDate")!=null)
              set(4, rs.getDate("orderDate").toString());

          if (rs.getDate("ShipDate")!=null)
              set(5, rs.getDate("ShipDate").toString());

          subTotal=rs.getBigDecimal("SubTotal");
          set(6, subTotal);

        } else {
          setSQLstate("02000");
        }
        break;

      // SQLUDF_TF_CLOSE
      // invoked after SQL State '02000' received
      // cleanup done here
      case SQLUDF_TF_CLOSE:
        rs.close();
        stmt.close();
        connection.close();

      // SQLUDF_TF_FINAL
      // invoked after SQLUDF_TF_CLOSE if UDTF 
      // definition has FINAL CALL specified.
      // Additional cleanup can be done here
      case SQLUDF_TF_FINAL:
        break;
      default:
        setSQLstate("38I04");
        setSQLmessage("Unknown call type");        
    }  // End switch
  }    // End Orders method
  
  //
  // This method is overridden to limit the number
  // of characters returned by an exception
  // to 69 characters.  setSQLmessage accepts
  // a maximum of 69.
  //
  public void setSQLmessage(String message) throws Exception {
    int msgLen=message.length();
    String tmpMessage=message.substring(0, (msgLen>69?69:msgLen));
    super.setSQLmessage(tmpMessage);
  }    // End setSQLmessage method
}      // End GetOrders class
