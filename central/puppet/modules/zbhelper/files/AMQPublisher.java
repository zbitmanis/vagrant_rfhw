import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.concurrent.TimeoutException;

import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.Channel;
 
public class AMQPublisher{
    private final static String QUEUE_NAME = "zpq";
 
    public static void main(String[] args) throws java.io.IOException {
       
            int  firstArg=0;
            if (args.length > 0) { 
                ConnectionFactory factory = new ConnectionFactory();
                factory.setHost("localhost");
                try {
                    firstArg = Integer.parseInt(args[0]);
                } catch (NumberFormatException e) {
                    System.err.println("Argument" + args[0] + " must be an integer.");
                    System.exit(1);
                }
                try {
                    Connection connection = factory.newConnection();
                    Channel channel = connection.createChannel();

                    channel.queueDeclare(QUEUE_NAME, false, false, false, null);
                    String message = Integer.toString(firstArg);
                    channel.basicPublish("", QUEUE_NAME, null, message.getBytes());
                    System.out.println(" [x] Sent '" + message + "'");
                
                    channel.close();
                    connection.close();                    
                } catch(TimeoutException toe) { 
                    System.out.println("TimeOut ocured :" + toe);
                    System.exit(0);
                }
           }
        
    }
}

