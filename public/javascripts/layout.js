const authArea = $("#authArea");

const fetchUser = async (userID) => {
	const res = await fetch(`/auth/user/${userID}`);
	const data = await res.json();
	return data;
};
const getCookie = (cname) => {
	let name = cname + "=";
	let decodedCookie = decodeURIComponent(document.cookie);
	let ca = decodedCookie.split(";");
	for (let i = 0; i < ca.length; i++) {
		let c = ca[i];
		while (c.charAt(0) == " ") {
			c = c.substring(1);
		}
		if (c.indexOf(name) == 0) {
			return c.substring(name.length, c.length);
		}
	}
	return "";
};

const renderAuth = async () => {
	const cookie = getCookie("userID");
	if (!cookie) {
		return authArea.html(
			`
			<div class="d-flex align-items-center gap-3">
				<a href="/auth/login" class="text-dark text-decoration-none">Đăng nhập</a>
				<a href="/auth/register" class="text-dark text-decoration-none">Đăng ký</a>
				<a href="/post" class="btn btn-outline-dark">Đăng tin</a>
			</div>
            `
		);
	}
	const data = await fetchUser(cookie);

	authArea.html(
		`
        <div class="d-flex gap-3 align-items-center" data-bs-container="body" data-bs-toggle="popover" data-bs-placement="bottom" data-bs-html="true" data-bs-content="<a href='/auth/logout' class='text-decoration-none'>Log out</a>">
			<div id="popover-area" class="d-flex gap-1 align-items-center">
				<i class="fa-solid fa-circle-user fa-lg"></i>
        	    <div>${data.body.name}</div>
			</div>
			<a class="btn btn-outline-dark" href="/post">Đăng tin</a>
        </div>
        `
	);
	$("#popover-area").click(() =>
		$(`[data-bs-toggle="popover"]`).popover("toggle")
	);
};
renderAuth();
