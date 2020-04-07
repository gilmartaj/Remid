package main

import (
	"fmt"
	"io"
	"os"
	"../../github.com/hajimehoshi/oto"
	"../../github.com/hajimehoshi/go-mp3"
)

func main() {
	
    arquivo, erro := os.Open(os.Args[1])
    if erro != nil {
		fmt.Println("Erro ao reproduzir.")
		os.Exit(1)
	}
    
    decodificador, erro := mp3.NewDecoder(arquivo)
    if erro != nil {
		fmt.Println("Erro ao reproduzir.")
		os.Exit(1)
	}
    
    reprodutor, erro := oto.NewPlayer(decodificador.SampleRate(), 2, 2, 8192)
    if erro != nil {
		fmt.Println("Erro ao reproduzir.")
		os.Exit(1)
	}
    
    if _, erro := io.Copy(reprodutor, decodificador); erro != nil {
        fmt.Printf("Erro ao reproduzir.")
        os.Exit(1)
    } else {
        fmt.Println("O áudio terminou de tocar.")
    }
}
