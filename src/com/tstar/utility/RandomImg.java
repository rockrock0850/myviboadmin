package com.tstar.utility;  
  
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.util.Random;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
     
/** 
 * 產生驗證碼圖片的servlet 
 * @author KT
 * 
 */  
public class RandomImg extends HttpServlet {     
       
    private static final long serialVersionUID = -5051097528828603895L;
    private final Logger logger = Logger.getLogger(RandomImg.class);
   
    /** 
    * 驗證碼圖片的寬度。  
    */  
    private int width = 100;     
       
    /** 
    *  驗證碼圖片的高度。 
    */  
    private int height = 30;     
     
    /** 
    * 驗證碼字符個數  
    */  
    private int codeCount = 4;     
     
    /** 
    * 字體高度    
    */  
    private int fontHeight;     
      
    /** 
    * 第一個字符的x軸值，因為後面的字符坐標依次遞增，所以它們的x軸值是codeX的倍數 
    */  
    private int codeX;     
      
    /** 
    * codeY ,驗證字符的y軸值，因為並行所以值一樣 
    */  
    private int codeY;     
     
    /** 
    * codeSequence 表示字符允許出現的序列值 
    */  
    char[] codeSequence = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',     
            'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W',     
            'X', 'Y', 'Z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' };     
     
    /**   
     * 初始化驗證圖片屬性   
     */    
    public void init() throws ServletException {     
        // 從web.xml中獲取初始信息     
        // 寬度     
        String strWidth = this.getInitParameter("width");     
        // 高度     
        String strHeight = this.getInitParameter("height");     
        // 字符個數     
        String strCodeCount = this.getInitParameter("codeCount");     
        // 將配置的信息轉換成數值     
        try {     
            if (strWidth != null && strWidth.length() != 0) {     
                width = Integer.parseInt(strWidth);     
            }     
            if (strHeight != null && strHeight.length() != 0) {     
                height = Integer.parseInt(strHeight);     
            }     
            if (strCodeCount != null && strCodeCount.length() != 0) {     
                codeCount = Integer.parseInt(strCodeCount);     
            }     
        } catch (NumberFormatException e) {  
            e.printStackTrace();  
        }     
        //width-4 除去左右多餘的位置，使驗證碼更加集中顯示，減得越多越集中。  
        //codeCount+1     //等比分配顯示的寬度，包括左右兩邊的空格  
        codeX = (width-4) / (codeCount+1);  
        //height - 10 集中顯示驗證碼  
        fontHeight = height - 10;    
        codeY = height - 7;   
    }     
     
    /** 
    * @param request 
    * @param response 
    * @throws ServletException 
    * @throws java.io.IOException 
    */  
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, java.io.IOException {     
        // 定義圖像buffer     
        BufferedImage buffImg = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);     
        Graphics2D gd = buffImg.createGraphics();     
        // 創建一個隨機數生成器類     
        Random random = new Random();     
        // 將圖像填充為白色     
        gd.setColor(Color.LIGHT_GRAY);     
        gd.fillRect(0, 0, width, height);     
        // 創建字體，字體的大小應該根據圖片的高度來定。     
        Font font = new Font("Fixedsys", Font.PLAIN, fontHeight);     
        // 設置字體。     
        gd.setFont(font);     
        // 畫邊框。     
        gd.setColor(Color.BLACK);     
        gd.drawRect(0, 0, width - 1, height - 1);     
        // 隨機產生160條干擾線，使圖像中的認證碼不易被其它程序探測到。     
        gd.setColor(Color.gray);     
        for (int i = 0; i < 16; i++) {     
            int x = random.nextInt(width);     
            int y = random.nextInt(height);     
            int xl = random.nextInt(12);     
            int yl = random.nextInt(12);     
            gd.drawLine(x, y, x + xl, y + yl);     
        }     
        // randomCode用於保存隨機產生的驗證碼，以便用戶登錄後進行驗證。     
        StringBuffer randomCode = new StringBuffer();     
        int red = 0, green = 0, blue = 0;     
        // 隨機產生codeCount數字的驗證碼。     
        for (int i = 0; i < codeCount; i++) {     
            // 得到隨機產生的驗證碼數字。     
            String strRand = String.valueOf(codeSequence[random.nextInt(36)]);     
            // 產生隨機的顏色份量來構造顏色值，這樣輸出的每位數字的顏色值都將不同。     
            red = random.nextInt(255);     
            green = random.nextInt(255);     
            blue = random.nextInt(255);     
            // 用隨機產生的顏色將驗證碼繪製到圖像中。     
            gd.setColor(new Color(red,green,blue));     
            gd.drawString(strRand, (i + 1) * codeX, codeY);     
            // 將產生的四個隨機數組合在一起。     
            randomCode.append(strRand);     
        }     
        // 將四位數字的驗證碼保存到Session中。     
        HttpSession session = request.getSession();    
        logger.debug(randomCode.toString());
        session.setAttribute("validateCode", randomCode.toString());  
        // 禁止圖像緩存。     
        response.setHeader("Pragma", "no-cache");     
        response.setHeader("Cache-Control", "no-cache");     
        response.setDateHeader("Expires", 0);     
     
        response.setContentType("image/jpeg");     
        // 將圖像輸出到Servlet輸出流中。     
        ServletOutputStream sos = response.getOutputStream();     
        ImageIO.write(buffImg, "jpeg", sos);  
        sos.close();     
    }     
}   