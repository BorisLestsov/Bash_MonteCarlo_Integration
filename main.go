package main

import "time"
import "fmt"
import "math/rand"
import "os"
import "strconv"
//import "reflect"

func f(x float32) float32 {
	return x*x
}

func monteCarlo(a, b, min, max float32, runs int) float32 {
	pos, neg := 0, 0
	diff_x := b-a
	diff_y := max-min
	if diff_x <= 0 || diff_y <= 0 {
		panic("Wrong bounds")
	}
	
	for i := 0; i < runs; i++ {
		rand_x := rand.Float32()*diff_x + a
		rand_y := rand.Float32()*diff_y + min
		if f(rand_x) > rand_y {
			pos++
		} else {
			neg++
		}
	}
	return float32(pos)/float32(runs)
}

func cvtFloat32OrDie(str string) float32 {
	val, err := strconv.ParseFloat(str, 32)
	if err != nil {
		panic(err)
	}
	return float32(val)
}

func cvtIntOrDie(str string) int {
	val, err := strconv.ParseInt(str, 10, 32)
	if err != nil {
		panic(err)
	}
	return int(val)
}

func main() {
	a    := cvtFloat32OrDie(os.Args[1])
	b    := cvtFloat32OrDie(os.Args[2])
	min  := cvtFloat32OrDie(os.Args[3])
	max  := cvtFloat32OrDie(os.Args[4])
	runs := cvtIntOrDie(os.Args[5])

	now := time.Now().UnixNano()
	rand.Seed(now)

	result := monteCarlo(a, b, min, max, runs)
	fmt.Println(result)
}