const bookmark = $("#bookmark");
let reid, userid, swal;
$(document).ready(() => {
	reid = window.location.pathname.replace("/post/", "");
	userid = getCookie("userID");
	swal = Swal;
});

const sendBookMark = async () => {
	if (!userid) return;
	if (!reid) return;
	const res = await fetch("/post/bookmark", {
		method: "POST",
		headers: {
			"Content-Type": "application/json",
		},
		body: JSON.stringify({ userid, reid }),
	});
	Swal.fire("Lưu tin thành công");
	const data = await res.json();
	return data;
};

bookmark.on("click", () => sendBookMark());
