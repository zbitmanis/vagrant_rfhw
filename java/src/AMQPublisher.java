import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.concurrent.TimeoutException;

import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.Channel;
 
public class AMQPublisher{
private final static String QUEUE_NAME = "zpq";
 
        public static void main(String[] args) 
                throws java.io.IOException {
               
                int radius = 0;
                System.out.println("Please enter radius of a circle");
                    ConnectionFactory factory = new ConnectionFactory();
                    factory.setHost("localhost");
                    try {
                        Connection connection = factory.newConnection();
                    Channel channel = connection.createChannel();

                    channel.queueDeclare(QUEUE_NAME, false, false, false, null);
                    String message = "Hello World!";
                    channel.basicPublish("", QUEUE_NAME, null, message.getBytes());
                    System.out.println(" [x] Sent '" + message + "'");
                    
                      channel.close();
                      connection.close();                    
                    } catch(TimeoutException toe) { 
                        System.out.println("TimeOut ocured :" + toe);
                        System.exit(0);
                    }

                
                /*try
                {
                        //get the radius from console
                        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
                        radius = Integer.parseInt(br.readLine());
                }
                //if invalid value was entered
                catch(NumberFormatException ne)
                {
                        System.out.println("Invalid radius value" + ne);
                        System.exit(0);
                }
                catch(IOException ioe)
                {
                        System.out.println("IO Error :" + ioe);
                        System.exit(0);
                }
                */
                /*
                 * Area of a circle is
                 * pi * r * r
                 * where r is a radius of a circle.
                 */
               /*
                //NOTE : use Math.PI constant to get value of pi
                double area = Math.PI * radius * radius;
               
                System.out.println("Area of a circle is " + area);
               */
        }
}
 
