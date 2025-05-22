using System;
using System.IO;
using System.Threading.Tasks;
using System.Diagnostics;

namespace LinuxApp
{
    public class MainApp
    {
        public static void Main(string[] args)
        {
            Console.WriteLine("iRemovalPRO v3.0 Serverless - Linux Edition");
            Console.WriteLine("===========================================");
            
            // Create directories for activation files and logs
            Directory.CreateDirectory("ActivationFiles");
            Directory.CreateDirectory("Logs");
            
            Console.WriteLine("Checking for libimobiledevice tools...");
            
            // Check if libimobiledevice tools are available
            bool iproxyAvailable = File.Exists("../tools/iproxy");
            bool idevicepairAvailable = File.Exists("../tools/idevicepair");
            bool ideviceactivationAvailable = File.Exists("../tools/ideviceactivation");
            
            Console.WriteLine($"iproxy available: {iproxyAvailable}");
            Console.WriteLine($"idevicepair available: {idevicepairAvailable}");
            Console.WriteLine($"ideviceactivation available: {ideviceactivationAvailable}");
            
            // Try to list connected devices
            Console.WriteLine("\nAttempting to list connected devices...");
            try
            {
                var process = new Process
                {
                    StartInfo = new ProcessStartInfo
                    {
                        FileName = "idevice_id",
                        Arguments = "-l",
                        UseShellExecute = false,
                        RedirectStandardOutput = true,
                        CreateNoWindow = true
                    }
                };
                
                process.Start();
                string output = process.StandardOutput.ReadToEnd();
                process.WaitForExit();
                
                if (string.IsNullOrWhiteSpace(output))
                {
                    Console.WriteLine("No devices connected.");
                }
                else
                {
                    Console.WriteLine("Connected devices:");
                    Console.WriteLine(output);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error listing devices: {ex.Message}");
            }
            
            Console.WriteLine("\nApplication is ready for use.");
            Console.WriteLine("Press any key to exit...");
            Console.ReadKey();
        }
    }
}
