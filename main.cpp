#include <btas/btas.h>
//#include <hdf5_hl.h>
// explicitly decompose a 3d tensor which is written in a H5 file
// and then write approximation back to H5 file
int main(int argc, char **argv){

    std::cout << argc << std::endl;
    int dim1 = 0, dim2 = 0, dim3 = 0, rank = 0;
    std::string input_file, output_file;
    if(argc > 5){
        dim1 = atoi(argv[1]);
        dim2 = atoi(argv[2]);
        dim3 = atoi(argv[3]);
        rank = atoi(argv[4]);
        std::cout << dim1 << std::endl;
        std::cout << dim2 << std::endl;
        std::cout << dim3 << std::endl;
        std::cout << rank << std::endl;
        input_file =  std::string(argv[5]) + ".h5";
        output_file = std::string(argv[6]) + ".h5";

        std::cout << input_file << std::endl;
        std::cout << output_file << std::endl;
    } else{
        std::cout << "Missing necessary input parameters" << std::endl;
        return 1;
    }
    using namespace btas;

    using tensor =
            Tensor<double, btas::Range, btas::varray<double>>;
            //Tensor<std::complex<double>, btas::Range, btas::varray<std::complex<double>>>;

    tensor T(dim1, dim2, dim3);
    auto fill=[](tensor & a){
        std::mt19937 generator(random_seed_accessor());
        std::uniform_real_distribution<> distribution(-1.0, 1.0);
        for (auto iter = a.begin(); iter != a.end(); ++iter) {
            *(iter) = distribution(generator);
        }
    };
    fill(T);

    double norm = sqrt(dot(T, T));
    FitCheck<tensor> fit(1e-3);
    fit.set_norm(norm);
    fit.verbose(true);

    CP_ALS<tensor, FitCheck<tensor>> CP(T);

    CP.compute_rank(rank, fit, 1, false, 0, 100, true, false, true);

    auto T_btas = CP.reconstruct();

    // write h5 file


return 0;
}
