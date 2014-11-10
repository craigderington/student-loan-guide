Public Shared Function EncryptAndEncodeMessage(ByVal message As String) As String
 
        Dim inData = Encoding.ASCII.GetBytes(message)
 
        '1. Compress
 
        Dim outData As Byte()
        Dim mem As New IO.MemoryStream
        Dim gz As New System.IO.Compression.DeflateStream(mem, IO.Compression.CompressionMode.Compress)
        Dim sw As New IO.StreamWriter(gz)
        sw.Write(message)
        sw.Close()
        outData = mem.ToArray()
 
        '2. Pad
 
        outData = Pad(outData)
 
        '3. Encrypt
 
        outData = Encrypt(outData)
 
        '4. Base 64 Encode
        Return Convert.ToBase64String(outData)
 
 
    End Function
 
    Public Shared Function DecryptAndDecodeMessage(ByVal message As String) As String
 
        '1. Decode
        message = message.Replace("-", "+")
        message = message.Replace("_", "/")
 
        Dim inData = Convert.FromBase64String(message)
 
        '2. Decrypt
        Dim outData3 = Decrypt(inData)
 
        '3. DeCompress
 
        Dim mem As New IO.MemoryStream(outData3.ToArray)
        Dim gz As New System.IO.Compression.DeflateStream(mem, IO.Compression.CompressionMode.Decompress)
        Dim sw As New IO.StreamReader(gz)
        Dim outData As String = sw.ReadLine()
        sw.Close()
 
        Return outData
 
    End Function
 
    Public Shared Function Encrypt(ByVal data As Byte()) As Byte()
 
        Dim encrypted As Byte()
 
        ' Create an RijndaelManaged object 
 
        ' with the specified key and IV. 
 
        Using rijAlg = New System.Security.Cryptography.AesManaged()
            ' Contact Vanco for your unique encryption key
            rijAlg.Key = Encoding.ASCII.GetBytes("encryptionkeyhere")
 
            rijAlg.Padding = System.Security.Cryptography.PaddingMode.None
 
            rijAlg.Mode = System.Security.Cryptography.CipherMode.ECB
 
            Dim encryptor = rijAlg.CreateEncryptor(rijAlg.Key, rijAlg.IV)
 
            Using msEncrypt = New MemoryStream()
 
                Using csEncrypt = New System.Security.Cryptography.CryptoStream(msEncrypt, encryptor, System.Security.Cryptography.CryptoStreamMode.Write)
 
                    csEncrypt.Write(data, 0, data.Length)
                End Using
 
                encrypted = msEncrypt.ToArray()
 
            End Using
        End Using
 
        ' Return the encrypted bytes from the memory stream. 
 
        Return encrypted
 
    End Function
 
    Public Shared Function Decrypt(ByVal data As Byte()) As Byte()
        'Public Shared Function Decrypt(ByVal data As String) As String
 
        Dim decrypted As Byte()
 
        ' Create an AesManaged object 
 
        ' with the specified key and IV. 
 
        Using rijAlg = New System.Security.Cryptography.AesManaged()
        ' Contact Vanco for your unique encryption key
            rijAlg.Key = Encoding.ASCII.GetBytes("encryptionkeyhere")
 
            rijAlg.Padding = System.Security.Cryptography.PaddingMode.None
 
            rijAlg.Mode = System.Security.Cryptography.CipherMode.ECB
 
            Dim decryptor = rijAlg.CreateDecryptor(rijAlg.Key, rijAlg.IV)
 
            Using msDecrypt = New MemoryStream()
 
                Using csDecrypt = New System.Security.Cryptography.CryptoStream(msDecrypt, decryptor, System.Security.Cryptography.CryptoStreamMode.Write)
 
                    csDecrypt.Write(data, 0, data.Length)
                End Using
 
                decrypted = msDecrypt.ToArray()
 
            End Using
        End Using
 
        ' Return the encrypted bytes from the memory stream. 
 
        Return decrypted
 
    End Function
 
    Public Shared Function Pad(ByVal input As Byte()) As Byte()
 
        Dim roundUpLength As Double = 16.0 * Math.Ceiling(CDbl(input.Length) / 16.0)
 
        Dim output = New Byte(CInt(roundUpLength) - 1) {}
 
 
        input.CopyTo(output, 0)
 
        For i As Integer = input.Length To CInt(roundUpLength) - 1
            output(i) = Encoding.ASCII.GetBytes(" ")(0)
        Next
 
        Return output
 
    End Function