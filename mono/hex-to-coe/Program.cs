using System;
using System.IO;

namespace hextocoe
{
    class MainClass
    {

        public static void HexConv(string pFileName)
        {
            if (!File.Exists(pFileName))
                throw new InvalidOperationException("no input file found");


            TextReader reader = File.OpenText(pFileName);
            string buf = reader.ReadLine();
            UInt16[] words = new UInt16[8196];
            int org = 0;

            while (buf.Length > 0)
            {
                if (!CheckHexLine(buf))
                    throw new InvalidOperationException("check sum error");

                int count = Convert.ToInt32(buf.Substring(1, 2), 16);
                int addr = Convert.ToInt32(buf.Substring(3, 4), 16);
                int rtyp = Convert.ToInt32(buf.Substring(7, 2), 16);

                if (count == 0 && rtyp == 0)
                    rtyp = 1; // DRI asm and mac fix

                if (rtyp == 1)
                    break;

                for (int i = 0; i < count; i += 2)
                {
                    byte lo = (byte)Convert.ToInt32(buf.Substring(9 + (i * 2), 2), 16);
                    byte hi = (byte)Convert.ToInt32(buf.Substring(9 + ((i + 1) * 2), 2), 16);
                    words[org++] = (UInt16)(((UInt16)hi << 8) | (UInt16)lo);
                    ++addr;
                }


                buf = reader.ReadLine();
            }

            reader.Close();

            string dir = Path.GetDirectoryName(pFileName);
            string name = Path.GetFileNameWithoutExtension(pFileName);
            string outname = Path.Combine(dir, name + ".coe");

            if (File.Exists(outname))
                File.Delete(outname);

            TextWriter writer = File.CreateText(outname);

            writer.WriteLine("memory_initialization_radix=16;");
            writer.WriteLine("memory_initialization_vector=");

            for (int i = 0; i < org - 1; ++i)
            {
                writer.Write(words[i].ToString("X4"));
                writer.WriteLine(",");
            }

            writer.Write(words[org-1].ToString("X4"));
            writer.WriteLine(";");

            writer.Close();
        }

        public static bool CheckHexLine(string pLine)
        {
            int ptr = 1;
            int sum = 0;

            while (ptr < pLine.Length)
            {
                sum += Convert.ToInt32(pLine.Substring(ptr, 2), 16);
                ptr += 2;
            }

            return (sum & 0xFF) == 0;
        }


        public static void Main(string[] args)
        {
            if (args.Length == 1)
            {
                Console.Write("converting " + args[0]);
                HexConv(args[0]);
            }
            else
            {
                Console.WriteLine("nothing to convert");
            }
        }
    }
}
