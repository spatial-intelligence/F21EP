##demo prefect script

from prefect import task,flow
from random import choice


@task
def choose_path():
    path = choice(["A", "B"])
    print(f"Decided to go down path {path}")
    return path

@task
def task_a1():
    print("Running Path A - Task 1")
    return "A1 done"

@task
def task_a2():
    print("Running Path A - Task 2")
    return "A2 done"

@task
def task_b1():
    print("Running Path B - Task 1")
    return "B1 done"

@task
def showresults(results):
    print(f"Results: {results}")


@flow
def path_a_flow():
    r1 = task_a1()
    r2 = task_a2()
    return [r1, r2]

@flow
def path_b_flow():
    r1 = task_b1()
    return [r1]

@flow
def main_flow():
    path = choose_path()
    if path == "A":
        results = path_a_flow()
    else:
        results = path_b_flow()
    showresults(results)

if __name__ == "__main__":
    main_flow()
