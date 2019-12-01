const cheerio = require('cheerio')
const https   = require('https')
const fs = require('fs');

var questions = Array()



function read(page) 
{
	let path = "./data/" + page + ".txt"
	let content = fs.readFileSync(path,"utf-8")
	let json = JSON.parse(content)

	for (var j = json.length - 1; j >= 0; j--) 
	{ 
		let newTitle = json[j].title
		var exist = false
		for (var i = questions.length - 1; i >= 0; i--) {
			if (newTitle == questions[i].title) {
				exist = true
				break
			}
		}
		if (exist == false) {
			questions.push(json[j])
		}
	}
	console.log(questions.length)
}

for (var i = 0; i <= 323; i++) {
	read(i)
}


fs.writeFile("./out.txt", JSON.stringify(questions), function(err) {}); 