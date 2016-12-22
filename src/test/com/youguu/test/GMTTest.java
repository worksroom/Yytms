package com.youguu.test;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * Created by SomeBody on 2016/8/19.
 */
public class GMTTest {
    public static void main(String[] args) throws ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("EEE MMM dd yyyy HH:mm:ss 'GMT'Z", Locale.US);
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        String str = "Mon Aug 01 2016 00:00:00 GMT+0800";
//        String str = "Thu Oct 16 07:13:48 GMT 2014";
        Date d = sdf.parse(str);
        System.out.println(dateFormat.format(d));


        Date dd = new Date();
        System.out.println(sdf.format(dd));
    }
}
