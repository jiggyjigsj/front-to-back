LogsLoc =[
  {
    'name': 'Plex Move',
    'location': 'up.log'
  },
  {
    'name': 'Second Log',
    'location': 'test.log'
  }
]

SendLogs = []

# Using for loop
for i, log in enumerate(LogsLoc):
  print(i)
  with open(log['location'],"r") as file:
    content = file.readlines()
  print(SendLogs)
  SendLogs.append({
    'name': log['name'],
    'content': content
  })
