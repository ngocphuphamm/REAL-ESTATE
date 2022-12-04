const city = document.getElementById('province');
const district = document.getElementById('district');
const ward = document.getElementById('ward');
const street = document.getElementById('street');
const project = document.getElementById('project');
const category = document.getElementById('category');

const fetchCategories = async () => {
    const res = await fetch(`/address/categories`);
    const data = await res.json();
    renderCategory(data);
};
const fetchInit = async () => {
    const res = await fetch(`/address/provinces`);
    const data = await res.json();
    renderAddress(data);
};
const fetchDistrict = async (id) => {
    const res = await fetch(`/address/districts/?provinceID=${id}}`);
    const data = await res.json();
    return data;
};
const fetchWard = async (district, province) => {
    const res = await fetch(`/address/wards/?districtID=${district}&provinceID=${province}`);
    const data = await res.json();
    return data;
};

const fetchStreet = async (district, province) => {
    const res = await fetch(`/address/streets/?districtID=${district}&provinceID=${province}`);
    const data = await res.json();
    return data;
};
const fetchProjectByDistrictAndProvince = async (district, province) => {
    const res = await fetch(
        `/address/projectsByDistrictAndProvince/?districtID=${district}&provinceID=${province}`
    );
    const data = await res.json();
    return data;
};
const fetchProjectByProvince = async (province) => {
    const res = await fetch(`/address/projectsByProvince/?provinceID=${province}`);
    const data = await res.json();
    return data;
};
function removeOptions(selectElement) {
    var i,
        L = selectElement.options.length - 1;
    for (i = L; i >= 0; i--) {
        selectElement.remove(i);
    }
    selectElement.options[selectElement.options.length] = new Option('Chọn', '');
}
const renderCategory = async (data) => {
    if (!category) return;
    for (let item of data) {
        category.options[category.options.length] = new Option(item.name, item.categoryid);
    }
};
const renderAddress = async (data) => {
    for (let item of data) {
        city.options[city.options.length] = new Option(item.nameprovince, item.provinceid);
    }
    city.onchange = async () => {
        removeOptions(district);
        removeOptions(ward);
        removeOptions(street);
        removeOptions(project);
        if (!city.value) return;
        const data = await fetchDistrict(city.value);
        for (let dis of data) {
            district.options[district.options.length] = new Option(
                dis.namedistrict,
                dis.districtid
            );
        }
        const projects = await fetchProjectByProvince(city.value);
        for (let p of projects) {
            project.options[project.options.length] = new Option(p.nameproject, p.projectid);
        }
    };
    district.onchange = async () => {
        removeOptions(ward);
        removeOptions(street);
        removeOptions(project);
        if (!district.value) return;
        const data = await fetchWard(district.value, city.value);
        for (let w of data) {
            ward.options[ward.options.length] = new Option(w.nameward, w.wardid);
        }
        const projects = await fetchProjectByDistrictAndProvince(district.value, city.value);
        for (let p of projects) {
            project.options[project.options.length] = new Option(p.nameproject, p.projectid);
        }
    };
    ward.onchange = async () => {
        removeOptions(street);
        removeOptions(project);
        if (!ward.value) return;
        const data = await fetchStreet(district.value, city.value);
        for (let s of data) {
            street.options[street.options.length] = new Option(s.namestreet, s.streetid);
        }
    };
    street.onchange = async () => {
        if (!street.value) return;
    };
};
fetchCategories();
fetchInit();
