package commitparser

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestCommits(t *testing.T) {

	t.Run("one commit", func(t *testing.T) {
		s := `
		commit 20e91e009e0176802a5aace0811949e9ea435d6e
Author: thenakulchawla <thenakulchawla@gmail.com>
Date:   Sat Jan 11 22:39:28 2025 -0800

    add some channel stuff`
		res, err := transform(s)
		require.Nil(t, err)
		require.Equal(t, 1, len(res))

	})

	t.Run("multiple", func(t *testing.T) {
		s := `
		commit 20e91e009e0176802a5aace0811949e9ea435d6e
Author: thenakulchawla <thenakulchawla@gmail.com>
Date:   Sat Jan 11 22:39:28 2025 -0800

    add some channel stuff

commit ebc907bdca1efe35f9e0b47cca940e6353806c3c
Author: thenakulchawla <thenakulchawla@gmail.com>
Date:   Sat Oct 12 23:57:10 2024 -0700

    add waitgroups and error groups

	this should be a long description and a bunch of things here.

commit c49c0f58b676ebf3a250d38f9026dcfbddb826ac
Author: thenakulchawla <thenakulchawla@gmail.com>
Date:   Sat Oct 12 12:02:46 2024 -0700

    Initial commit
		
		`
		res, err := transform(s)
		require.Nil(t, err)
		require.Equal(t, 3, len(res))
		require.Equal(t, res[0].Author, "thenakulchawla")
	})

}
