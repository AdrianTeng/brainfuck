package io.teng.brainfuck;

import org.junit.Test;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;

import static org.junit.Assert.*;

/**
 * Created by ateng on 01/01/15.
 */
public class TestBrainfuckInterpreter {

    @Test
    public void testHelloWorld(){
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        System.setOut(new PrintStream(baos));
        new BrainfuckInterpreter("../helloworld.bf", "").interpret();
        assertEquals(baos.toString(), "Hello World!\n");
    }

    @Test
    public void testRot13(){
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        System.setOut(new PrintStream(baos));
        new BrainfuckInterpreter("../rot13.bf", "abcdefghijklmnopqrstuvwxyz").interpret();
        assertEquals(baos.toString(), "nopqrstuvwxyzabcdefghijklm");
    }
}
