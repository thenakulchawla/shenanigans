package random

import (
	"context"

	"github.com/thenakulchawla/parchment"
)

func main() {
	ctx := context.Background()
	ctx = parchment.New(ctx)
	ctx = parchment.AddToLogger(ctx, []parchment.LoggerField{
		{Key: "key", Value: "value"},
	})
	funcCall(ctx)
}

func funcCall(ctx context.Context) {
	log := parchment.FromContext(ctx)
	log.Info().Msg("hell with values")
}
