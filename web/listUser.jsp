<%@page import="java.time.LocalDateTime"%>
<%@page import="model.UserRegister"%>
<%@page import="model.User"%>
<%@page import="model.Transaction"%>
<%@page import="dal.UserDAO"%>
<%@page import="model.User"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- Include jQuery library -->

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script>
    $(document).ready(function () {
        // Bắt sự kiện khi nhấn vào liên kết "Free Account," "Premium Account," hoặc "Author Account"
        $(".filter-link").click(function (e) {
            e.preventDefault(); // Ngăn chặn mặc định của liên kết

            var filterValue = $(this).data("filter");

            // Ẩn/hiển thị các phần tử dựa trên lớp CSS
            if (filterValue === "All") {
                // Hiển thị tất cả các phần tử
                $(".free-account, .premium-account, .author-account").show();
            } else {
                // Ẩn tất cả các phần tử
                $(".free-account, .premium-account, .author-account").hide();

                // Hiển thị chỉ các phần tử có lớp CSS tương ứng
                $("." + filterValue.toLowerCase() + "-account").show();
            }
        });
    });
</script>
<script>
    $(document).ready(function () {
        // Bắt sự kiện khi nhấn vào liên kết "All Account", "Free Account", "Premium Account" hoặc "Author Account"
        $(".filter-link").click(function (e) {
            e.preventDefault(); // Ngăn chặn mặc định của liên kết

            var filterValue = $(this).data("filter");

            // Ẩn tất cả các hàng trước khi lọc
            $("tr").hide();

            if (filterValue === "All") {
                // Hiển thị tất cả các hàng
                $("tr").show();
            } else {
                // Hiển thị chỉ các hàng có vai trò tương ứng
                $("tr." + filterValue).show();
            }
        });
    });
</script>
<%

    if (session.getAttribute("userSession") == null) {
        response.sendRedirect("login.jsp");
    }


%>

<!DOCTYPE html>
<html lang="en">

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <meta content="width=device-width, initial-scale=1.0" name="viewport">

        <title>Users / Profile</title>
        <meta content="" name="description">
        <meta content="" name="keywords">

        <!-- Favicons -->
        <link href="assetsUser/img/logo.png" rel="icon">
        <link href="assetsUser/img/apple-touch-icon.png" rel="apple-touch-icon">

        <!-- Google Fonts -->
        <link href="https://fonts.gstatic.com" rel="preconnect">
        <link
            href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i"
            rel="stylesheet">

        <!-- Vendor CSS Files -->
        <link href="assetsUser/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link href="assetsUser/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
        <link href="assetsUser/vendor/boxicons/css/boxicons.min.css" rel="stylesheet">
        <link href="assetsUser/vendor/quill/quill.snow.css" rel="stylesheet">
        <link href="assetsUser/vendor/quill/quill.bubble.css" rel="stylesheet">
        <link href="assetsUser/vendor/remixicon/remixicon.css" rel="stylesheet">
        <link href="assetsUser/vendor/simple-datatables/style.css" rel="stylesheet">
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">

        <!-- Template Main CSS File -->
        <link href="assetsUser/css/style.css" rel="stylesheet">
    </head>

    <body>
        <%@include file="layouts/layoutsAdmin/headerAdmin.jsp" %> 
        <%@include file="layouts/layoutsAdmin/sidebarAdmin.jsp" %> 

        <main id="main" class="main">

            <div class="pagetitle">
                <h1>Dashboard</h1>
                <nav>
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="home.jsp">Home</a></li>
                        <li class="breadcrumb-item active">List User</li>
                    </ol>
                </nav>
            </div><!-- End Page Title -->

            <section class="section dashboard">
                <div class="row">
                    <!-- Report -->
                    <div class="free-account premium-account author-account">
                        <div class="col-12">
                            <section class="section dashboard">
                                <div class="row">
                                    <!-- Report -->
                                    <div class="col-12">
                                        <div class="card top-selling overflow-auto">

                                            <div class="filter">
                                                <a class="icon" href="#" data-bs-toggle="dropdown"><i class="bi bi-three-dots"></i></a>
                                                <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow">
                                                    <li class="dropdown-header text-start">
                                                        <h6>Filter</h6>
                                                    </li>
                                                    <li><a class="dropdown-item filter-link" href="#" data-filter="All">All Account</a></li>
                                                    <li><a class="dropdown-item filter-link" href="#" data-filter="Free">Free Account</a></li>
                                                    <li><a class="dropdown-item filter-link" href="#" data-filter="Premium">Premium Account</a></li>
                                                    <li><a class="dropdown-item filter-link" href="#" data-filter="Author">Author Account</a></li>
                                                </ul>
                                            </div>

                                            <div class="card-body pb-0">
                                                <h5 class="card-title">List User <span></span></h5>

                                                <table class="table table-bordered table-striped">
                                                    <thead>
                                                        <tr>
                                                            <th scope="col">UserName</th>
                                                            <th scope="col">Create AT</th>
                                                            <th scope="col">Coin Quantity</th>
                                                            <th scope="col">Role</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <%
                                                            Connection connection = null; // Thiết lập kết nối cơ sở dữ liệu ở đây
                                                            try {
                                                                UserDAO userDAO = new UserDAO();
                                                                List<User> userList = userDAO.getUsersData();
                                                                for (User a : userList) {
                                                        %>
                                                        <tr class="<%= a.getRole()%>">
                                                            <td><%= a.getUsername()%></td>
                                                            <td><%= a.getCreateAt()%></td>
                                                            <td><%= a.getCoinQuantity()%></td>
                                                            <td><%= a.getRole()%></td>
                                                            <td>
                                                                <a href="DeleteUser?userId=<%= a.getUserId()%>">Delete</a>
                                                            </td>
                                                        </tr>
                                                        <%
                                                                }
                                                            } catch (Exception e) {
                                                                e.printStackTrace();
                                                            } finally {
                                                                // Đảm bảo đóng kết nối sau khi hoàn thành
                                                                try {
                                                                    if (connection != null) {
                                                                        connection.close();
                                                                    }
                                                                } catch (SQLException e) {
                                                                    e.printStackTrace();
                                                                }
                                                            }
                                                        %>
                                                    </tbody>
                                                </table>

                                            </div>

                                        </div>
                                    </div><!-- Report -->
                                </div>
                            </section>
                        </div>
                    </div>                                             

                    <div class="col-12">
                        <div class="card recent-sales overflow-auto">

                            <div class="filter">
                                <a class="icon" href="#" data-bs-toggle="dropdown"><i class="bi bi-three-dots"></i></a>
                                <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow">
                                    <li class="dropdown-header text-start">
                                        <h6>Filter</h6>
                                    </li>

                                    <li><a class="dropdown-item1" href="#">Today</a></li>
                                    <li><a class="dropdown-item1" href="#">This Month</a></li>
                                    <li><a class="dropdown-item1" href="#">This Year</a></li>
                                </ul>
                            </div>

                            <div class="card-body">
                                <h5 class="card-title">Recent Transaction <span>| Today</span></h5>
                                <table border="1">
                                    <tr>
                                        <th>ID</th>
                                        <th>Số hóa đơn</th>
                                        <th>Mã giao dịch</th>
                                        <th>Ngân hàng</th>
                                        <th>Nội dung thanh toán</th>
                                        <th>Số tiền</th>
                                        <th>Ngày tạo</th>
                                        <th>Trạng thái</th>
                                    </tr>
                                    <%
                                        UserDAO transactionDAO = new UserDAO();
                                        List<Transaction> transactionList = transactionDAO.getTransaction();
                                        for (Transaction transaction : transactionList) {
                                    %>
                                    <tr>
                                        <td><%= transaction.getId()%></td>
                                        <td><%= transaction.getInvoiceNumber()%></td>
                                        <td><%= transaction.getTransactionCode()%></td>
                                        <td><%= transaction.getBank()%></td>
                                        <td><%= transaction.getPaymentContent()%></td>
                                        <td><%= transaction.getAmount()%></td>
                                        <td><%= transaction.getDateofpayment()%></td>
                                        <td><%= transaction.getStatus()%></td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </table>



                            </div>

                        </div>
                    </div>

                    <!-- Top Selling -->
                    <div class="col-12">
                        <div class="card top-selling overflow-auto">

                            <div class="filter">
                                <a class="icon" href="#" data-bs-toggle="dropdown"><i class="bi bi-three-dots"></i></a>
                                <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow">
                                    <li class="dropdown-header text-start">
                                        <h6>Filter</h6>
                                    </li>

                                    <li><a class="dropdown-item" href="#">Today</a></li>
                                    <li><a class="dropdown-item" href="#">This Month</a></li>
                                    <li><a class="dropdown-item" href="#">This Year</a></li>
                                </ul>
                            </div>

                            <div class="card-body pb-0">
                                <h5 class="card-title">Top Selling <span>| Today</span></h5>

                                <table class="table table-borderless">
                                    <thead>
                                        <tr>
                                            <th scope="col">Preview</th>
                                            <th scope="col">Manga</th>
                                            <th scope="col">Price</th>
                                            <th scope="col">Sold</th>
                                            <th scope="col">Revenue</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <th scope="row"><a href="#"><img src="assets/img/product-1.jpg" alt=""></a></th>
                                            <td><a href="#" class="text-primary fw-bold">Ut inventore ipsa voluptas nulla</a></td>
                                            <td>$64</td>
                                            <td class="fw-bold">124</td>
                                            <td>$5,828</td>
                                        </tr>
                                        <tr>
                                            <th scope="row"><a href="#"><img src="assets/img/product-2.jpg" alt=""></a></th>
                                            <td><a href="#" class="text-primary fw-bold">Exercitationem similique doloremque</a></td>
                                            <td>$46</td>
                                            <td class="fw-bold">98</td>
                                            <td>$4,508</td>
                                        </tr>
                                        <tr>
                                            <th scope="row"><a href="#"><img src="assets/img/product-3.jpg" alt=""></a></th>
                                            <td><a href="#" class="text-primary fw-bold">Doloribus nisi exercitationem</a></td>
                                            <td>$59</td>
                                            <td class="fw-bold">74</td>
                                            <td>$4,366</td>
                                        </tr>
                                        <tr>
                                            <th scope="row"><a href="#"><img src="assets/img/product-4.jpg" alt=""></a></th>
                                            <td><a href="#" class="text-primary fw-bold">Officiis quaerat sint rerum error</a></td>
                                            <td>$32</td>
                                            <td class="fw-bold">63</td>
                                            <td>$2,016</td>
                                        </tr>
                                        <tr>
                                            <th scope="row"><a href="#"><img src="assets/img/product-5.jpg" alt=""></a></th>
                                            <td><a href="#" class="text-primary fw-bold">Sit unde debitis delectus repellendus</a></td>
                                            <td>$79</td>
                                            <td class="fw-bold">41</td>
                                            <td>$3,239</td>
                                        </tr>
                                    </tbody>
                                </table>

                            </div>

                        </div>
                    </div><!-- End Top Selling -->

                </div>
                </div><!-- End Left side columns -->


            </section>

        </main><!-- End #main -->

        <!-- ======= Footer ======= -->
        <footer id="footer" class="footer">
            <div class="copyright">
                &copy; Copyright <strong><span>MangaUniverse</span></strong>. All Rights Reserved
            </div>
            <div class="credits">
                <!-- All the links in the footer should remain intact. -->
                <!-- You can delete the links only if you purchased the pro version. -->
                <!-- Licensing information: https://bootstrapmade.com/license/ -->
                <!-- Purchase the pro version with working PHP/AJAX contact form: https://bootstrapmade.com/nice-admin-bootstrap-admin-html-template/ -->

            </div>
        </footer><!-- End Footer -->

        <a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>

        <!-- Vendor JS Files -->
        <script src="assetsUser/vendor/apexcharts/apexcharts.min.js"></script>
        <script src="assetsUser/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
        <script src="assetsUser/vendor/chart.js/chart.umd.js"></script>
        <script src="assetsUser/vendor/echarts/echarts.min.js"></script>
        <script src="assetsUser/vendor/quill/quill.min.js"></script>
        <script src="assetsUser/vendor/simple-datatables/simple-datatables.js"></script>
        <script src="assetsUser/vendor/tinymce/tinymce.min.js"></script>
        <script src="assetsUser/vendor/php-email-form/validate.js"></script>

        <!-- Template Main JS File -->
        <script src="assetsUser/js/main.js"></script>
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    </body>

</html>