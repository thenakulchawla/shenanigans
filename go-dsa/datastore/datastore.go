package datastore

type Transaction struct {
	values map[string]int
	parent *Transaction
}

type Database struct {
	current *Transaction
}

func NewDatabase() *Database {
	return &Database{
		current: &Transaction{
			values: make(map[string]int),
			parent: nil,
		},
	}
}

func (db *Database) Begin() {
	// Create new transaction with copy of current values
	newTx := &Transaction{
		values: make(map[string]int),
		parent: db.current,
	}

	// Copy current values to new transaction
	for k, v := range db.current.values {
		newTx.values[k] = v
	}

	// Set new transaction as current
	db.current = newTx
}

func (db *Database) Set(key string, value int) {
	db.current.values[key] = value
}

func (db *Database) Get(key string) (int, bool) {
	value, exists := db.current.values[key]
	return value, exists
}

func (db *Database) Commit() bool {
	if db.current.parent == nil {
		return false // No transaction to commit
	}

	// Copy current transaction's values to parent
	for k, v := range db.current.values {
		db.current.parent.values[k] = v
	}

	// Move back to parent transaction
	db.current = db.current.parent
	return true
}

func (db *Database) Rollback() bool {
	if db.current.parent == nil {
		return false // No transaction to rollback
	}

	// Simply move back to parent transaction
	// All changes in current transaction are discarded
	db.current = db.current.parent
	return true
}
