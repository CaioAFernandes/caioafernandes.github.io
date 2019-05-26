var dark = document.querySelector('#switch');
var darkMode = localStorage.getItem('dark-mode');
document.addEventListener('readystatechange', ()=>{
	switch (document.readyState) {
 		case "complete":
	 		dark.addEventListener('click', ()=>{
			    if (dark.checked) {
			        document.documentElement.classList.toggle('dark');
			    	localStorage.setItem('dark-mode', true);
			    }else{
			        document.documentElement.classList.remove('dark');
			    	if(darkMode){
 						localStorage.removeItem('dark-mode');
 					}
			    }
			});
	 		if(darkMode){
 				document.documentElement.classList.toggle('dark');
 				dark.checked = true;
 			}
 			break;
 	}
});
