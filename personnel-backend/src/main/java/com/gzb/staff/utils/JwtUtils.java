package com.gzb.staff.utils;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.util.StringUtils;

import jakarta.servlet.http.HttpServletRequest;
import java.util.Date;
import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;


public class JwtUtils {

    //token过期时间
    public static final long EXPIRE = 1000 * 60 * 60 * 24;
    //密钥 - 确保长度足够安全(至少32字节)
    public static final String APP_SECRET = "ukc8BDbRigUDaY6pZFfWus2jSHSecretKey123456789";
    
    // 获取密钥
    private static SecretKey getSigningKey() {
        return Keys.hmacShaKeyFor(APP_SECRET.getBytes(StandardCharsets.UTF_8));
    }
    
    //生成token字符串的方法
    public static String getJwtToken(String id, String nickname){

        String JwtToken = Jwts.builder()
                //设置主题和时间
                .subject("ser")
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + EXPIRE))
                //设置token主体部分
                .claim("id", id)
                .claim("nickname", nickname)
                //设置签名
                .signWith(getSigningKey())
                .compact();

        return JwtToken;
    }

    /**
     * 判断token是否存在与有效
     */
    public static boolean checkToken(String jwtToken) {
        if(StringUtils.isEmpty(jwtToken)) return false;
        try {
            Jwts.parser().verifyWith(getSigningKey()).build().parseSignedClaims(jwtToken);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    /**
     * 判断token是否存在与有效
     */
    public static boolean checkToken(HttpServletRequest request) {
        try {
            String jwtToken = request.getHeader("token");
            if(StringUtils.isEmpty(jwtToken)) return false;
            Jwts.parser().verifyWith(getSigningKey()).build().parseSignedClaims(jwtToken);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    /**
     * 根据token获取会员id
     */
    public static String getMemberIdByJwtToken(HttpServletRequest request) {
        String jwtToken = request.getHeader("token");
        if(StringUtils.isEmpty(jwtToken)) return "";
        Jws<Claims> claimsJws = Jwts.parser().verifyWith(getSigningKey()).build().parseSignedClaims(jwtToken);
        Claims claims = claimsJws.getPayload();
        return (String)claims.get("id");
    }
    /**
     * 根据token获取会员id
     */
    public static String getMemberIdByToken(String token) {
        if(StringUtils.isEmpty(token)) return "";
        Jws<Claims> claimsJws = Jwts.parser().verifyWith(getSigningKey()).build().parseSignedClaims(token);
        Claims claims = claimsJws.getPayload();
        return (String)claims.get("id");
    }
}
