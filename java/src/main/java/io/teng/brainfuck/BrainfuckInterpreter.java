package io.teng.brainfuck;

import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.FileSystems;
import java.nio.file.Path;
import java.util.List;

import static java.nio.file.Files.readAllLines;

/**
 * Created by ateng on 28/12/14.
 */
public class BrainfuckInterpreter {

    private final String fileName;
    private final String arg;

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


    public void interpret(){
    }


    public static void main(String[] args) throws IOException {
        String arg = "";
        if (args.length < 1) {
            throw new IllegalArgumentException("Missing Brainfuck input files.");
        } else if (args.length > 2) {
            arg = args[1];
        }
        String fileName = args[0];
        new BrainfuckInterpreter(fileName, arg).parseFile();

    }
}
