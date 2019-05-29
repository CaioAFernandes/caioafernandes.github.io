var dark = document.querySelector('#switch');
dark.addEventListener('click', ()=>{
    if (dark.checked) {
        document.documentElement.classList.toggle('dark');
    }else{
        document.documentElement.classList.remove('dark');
    }
})