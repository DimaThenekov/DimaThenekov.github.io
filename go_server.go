package main

import (
    "fmt"
    "net/http"
)

func main() {
    // Обработчик для корневого пути
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(w, "Привет! Сервер работает!\n")
        fmt.Fprintf(w, "Попробуйте перейти на /hello или /about\n")
    })

    // Обработчик для /hello
    http.HandleFunc("/hello", func(w http.ResponseWriter, r *http.Request) {
        name := r.URL.Query().Get("name")
        if name == "" {
            name = "Гость"
        }
        fmt.Fprintf(w, "Привет, %s!\n", name)
    })

    // Обработчик для /about
    http.HandleFunc("/about", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(w, "Это простой HTTP-сервер на Go\n")
        fmt.Fprintf(w, "Версия: 1.0\n")
    })

    // Обработчик для /status
    http.HandleFunc("/status", func(w http.ResponseWriter, r *http.Request) {
        w.Header().Set("Content-Type", "application/json")
        fmt.Fprintf(w, `{"status": "ok", "message": "Сервер работает"}`)
    })

    // Стартуем сервер
    port := "8080"
    fmt.Printf("Сервер запущен на http://localhost:%s\n", port)
    fmt.Println("Нажмите Ctrl+C для остановки")

    if err := http.ListenAndServe(":"+port, nil); err != nil {
        fmt.Printf("Ошибка запуска сервера: %v\n", err)
    }
}
