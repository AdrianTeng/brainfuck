package io.teng.brainfuck;

import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.FileSystems;
import java.nio.file.Path;
import java.util.*;

import static java.nio.file.Files.readAllLines;

/**
 * Created by ateng on 28/12/14.
 */
public class BrainfuckInterpreter {

    private final String fileName;
    private final String arg;
    private Map<Integer, Integer> bracketMap;

    public BrainfuckInterpreter(String fileName, String arg) {
        this.fileName = fileName;
        this.arg = arg;
    }

    private String parseFile() throws IOException {
        Path path = FileSystems.getDefault().getPath(fileName);
        List<String> lines = readAllLines(path, Charset.defaultCharset());
        StringBuilder builder = new StringBuilder();
        for (String line: lines){
            builder.append(line);
        }
        return builder.toString();
    }


    public void interpret() {
        String source;
        List<Integer> heap = new ArrayList<Integer>(Collections.nCopies(100, 0));
        int dataPtr = 0;
        try {
            source = parseFile();
        } catch (IOException e) {
            throw new RuntimeException("Unable to read source file.", e);
        }
        Map<Integer, Integer> bracketMap = genBracketMap(source);
        for (int i=0; i < source.length(); i++) {
            char c = source.charAt(i);
            switch (c){
                case '>':
                    dataPtr++; break;
                case '<':
                    dataPtr--; break;
                case '+':
                    heap.set(dataPtr, heap.get(dataPtr) + 1); break;
                case '-':
                    heap.set(dataPtr, heap.get(dataPtr) - 1); break;
                case '[':
                    if (heap.get(dataPtr) == 0)
                        i = bracketMap.get(i);
                    break;
                case ']':
                    if (heap.get(dataPtr) != 0) {
                        for (Map.Entry<Integer, Integer> entry: bracketMap.entrySet()) {
                            if (i == entry.getValue()) {
                                i = entry.getKey();
                                break;
                            }
                        }
                    }
                    break;
                case '.':
                    System.out.printf("%s", (char) heap.get(dataPtr).intValue()); break;
            }
        }

    }

    private Map<Integer, Integer> genBracketMap(String source){
        Map<Integer, Integer> bracketMap = new HashMap<Integer, Integer>();
        Stack<Integer> tempBracketStack = new Stack<Integer>();
        for (Integer i=0; i < source.length(); i++) {
            char c = source.charAt(i);
            switch (c){
                case '[':
                    tempBracketStack.push(i); break;
                case ']':
                    bracketMap.put(tempBracketStack.pop(), i); break;
            }
        }
        return bracketMap;
    }


    public static void main(String[] args) throws IOException {
        String arg = "";
        if (args.length < 1) {
            throw new IllegalArgumentException("Missing Brainfuck input files.");
        } else if (args.length > 2) {
            arg = args[1];
        }
        String fileName = args[0];
        new BrainfuckInterpreter(fileName, arg).interpret();
    }
}
