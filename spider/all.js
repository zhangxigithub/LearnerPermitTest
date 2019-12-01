const cheerio = require('cheerio')
const https   = require('https')


let paperURL  = 'https://www.vicroads.vic.gov.au/licences/your-ls/get-your-ls/lpt/lptoffline'
let answerURL = 'https://www.vicroads.vic.gov.au/licences/your-ls/get-your-ls/lpt/lptoffline/lptcorrectionsheet?testref='

var page = 0
function getPaper()
{

https.get(paperURL, (resp) => {
  
  let data = '';
  resp.on('data', (chunk) => {
    data += chunk;
  });
  resp.on('end', () => {
  	const $ = cheerio.load(data)

  	questions = []

	$('div.lpt-area').each(function(i, elem) 
	{
		if ( i < 1 ) {return true}

		var title = $(elem).find('h3').first().text().replace(String(i)+'. ','')
		console.log(title);

		var img = $(elem).find('img').first().attr("src")
		//console.log(img);

		var a1 = $($(elem).find('td')[0]).text()
		var a2 = $($(elem).find('td')[1]).text()
		var a3 = $($(elem).find('td')[2]).text()
		
		//console.log(a1)

		var obj = Object()
		obj.title = title
		obj.answers = [a1,a2,a3]
		if (typeof img != 'undefined')
		{
			obj.img = 'https://www.vicroads.vic.gov.au'+img
		}

		questions.push(obj)
	});



 var id = $('ul.lpt-printsummary li').first().text().replace('Practice Test Ref #: ','')



https.get(answerURL+id, (resp) => {
  
  let data = '';
  resp.on('data', (chunk) => {
    data += chunk;
  });
  resp.on('end', () => {
  	const $ = cheerio.load(data)


	$('td[class!=notes]').each(function(i, elem) 
		{
			questions[i].answer = $(elem).text();
		});
	console.log(questions)

	var fs = require('fs');
	var name = "./data/"+ page +".txt"
	page = page + 1
	fs.writeFile(name, JSON.stringify(questions), function(err) {
    if(err) {
        return console.log(err);
    }

	});
	getPaper() 

  });
 
})

  });
 
})
}





getPaper()