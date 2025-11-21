from fastapi import FastAPI, Query
import duckdb
import pandas as pd

app = FastAPI()
con = duckdb.connect(database=':memory:')

# Load sample data
df = pd.read_csv("events.csv")
con.register("events", df)

@app.get("/stats")
def get_stats(player_id: int = Query(...)):
    query = """
    SELECT player_id, COUNT(*) as events_count, AVG(score) as avg_score
    FROM events
    WHERE player_id = ?
    GROUP BY player_id
    """
    result = con.execute(query, [player_id]).fetchdf()
    return result.to_dict(orient="records")
