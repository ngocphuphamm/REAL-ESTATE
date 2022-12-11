const authArea = $('#authArea');

const fetchUser = async (userID) => {
    const res = await fetch(`/user/detailApi/${userID}`);
    const data = await res.json();
    return data;
};
const Toast = Swal.mixin({
    toast: true,
    position: 'bottom-end',
    showConfirmButton: false,
    timer: 3000,
    timerProgressBar: true,
    didOpen: (toast) => {
        toast.addEventListener('mouseenter', Swal.stopTimer);
        toast.addEventListener('mouseleave', Swal.resumeTimer);
    },
});

const getCookie = (cname) => {
    let name = cname + '=';
    let decodedCookie = decodeURIComponent(document.cookie);
    let ca = decodedCookie.split(';');
    for (let i = 0; i < ca.length; i++) {
        let c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }
    return '';
};

const renderAuth = async () => {
    const cookie = getCookie('userID');
    if (!cookie) {
        return authArea.html(
            `
			<div class="d-flex align-items-center gap-3">
				<a href="/auth/login" class="text-dark text-decoration-none">Đăng nhập</a>
				<a href="/auth/register" class="text-dark text-decoration-none">Đăng ký</a>
			</div>
            `
        );
    }

    const data = await fetchUser(cookie);
    const htmlForUser = `<div class="d-flex gap-3 align-items-center dropdown">
				<ul class="dropdown-menu">
                    <li><a class="dropdown-item" href="/user/${getCookie(
                        'userID'
                    )}">Thông tin cá nhân</a></li></li>
                    <li><a class="dropdown-item" href="/user/${getCookie(
                        'userID'
                    )}/myPost">Tin của tôi</a></li>
					<li><a class="dropdown-item" href="/user/${getCookie('userID')}/bookmark">Tin đã lưu</a></li>
					<li><a class="dropdown-item" href="/auth/logout">Đăng xuất</a></li>
				</ul>
				<div class="d-flex gap-1 align-items-center dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false" >
					<i class="fa-solid fa-circle-user fa-lg"></i>
					<div>${data.body.name}</div>
				</div>
				<a class="btn btn-outline-dark" href="/post">Đăng tin</a>
        	</div>`;
    const htmlForAdmin = `<div class="d-flex gap-3 align-items-center dropdown">
				<ul class="dropdown-menu">
                    <li><a class="dropdown-item" href="/admin/user">Quản lý</a></li>
                    <li><a class="dropdown-item" href="/user/${getCookie(
                        'userID'
                    )}">Thông tin cá nhân</a></li></li>
                    <li><a class="dropdown-item" href="/user/${getCookie(
                        'userID'
                    )}/myPost">Tin của tôi</a></li>
					<li><a class="dropdown-item" href="/user/${getCookie('userID')}/bookmark">Tin đã lưu</a></li>
					<li><a class="dropdown-item" href="/auth/logout">Đăng xuất</a></li>
				</ul>
				<div class="d-flex gap-1 align-items-center dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false" >
					<i class="fa-solid fa-circle-user fa-lg"></i>
					<div>${data.body.name}</div>
				</div>
				<a class="btn btn-outline-dark" href="/post">Đăng tin</a>
        	</div>`;
    data?.body?.typeuser === 0 ? authArea.html(htmlForUser) : authArea.html(htmlForAdmin);
};

renderAuth();
