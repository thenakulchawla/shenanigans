package consumer

import (
	"sync"
	"time"

	"github.com/rs/zerolog/log"
)

func produce(wg *sync.WaitGroup, link chan int, i int) {
	defer wg.Done()

	link <- i
	log.Info().Int("food_num", i).Msg("produced food")
	time.Sleep(3 * time.Second)
}

func consume(link chan int, done chan struct{}) {
	for {
		select {
		case food, ok := <-link:
			if !ok {
				done <- struct{}{}
				return
			}
			log.Info().Int("food_num", food).Msg("consuming food")
			time.Sleep(1 * time.Second)
		}
	}

}

func RunPC() {

	var food []int
	for i := range 10 {
		food = append(food, i)
	}

	var wg sync.WaitGroup
	foodChan := make(chan int, 3)
	doneChan := make(chan struct{})

	go func() {
		consume(foodChan, doneChan)
	}()

	for i := range food {
		wg.Add(1)
		go produce(&wg, foodChan, i)
	}

	wg.Wait()
	close(foodChan)
	<-doneChan
}
